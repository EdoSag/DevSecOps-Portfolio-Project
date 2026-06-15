# syntax=docker/dockerfile:1

# ---- Build stage ----
# Debian-based (glibc) to match the distroless runtime below - required for
# the native sqlite3 bindings to load correctly (musl/glibc mismatch otherwise).
FROM node:20-bookworm-slim AS build
WORKDIR /app
COPY package*.json ./
# Force sqlite3's native binding to be compiled here against this stage's
# glibc (Debian 12 bookworm) instead of using a prebuilt binary linked
# against a newer glibc than the distroless bookworm runtime provides.
RUN apt-get update && apt-get install -y --no-install-recommends python3 make g++ \
    && npm_config_build_from_source=true npm ci --omit=dev \
    && apt-get purge -y --auto-remove python3 make g++ \
    && rm -rf /var/lib/apt/lists/*
COPY src ./src

# ---- Runtime stage ----
FROM gcr.io/distroless/nodejs20-debian12:nonroot
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/src ./src
COPY package.json ./
EXPOSE 3000
CMD ["src/index.js"]
