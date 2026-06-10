# syntax=docker/dockerfile:1

# ---- Build stage ----
# Debian-based (glibc) to match the distroless runtime below - required for
# the native sqlite3 bindings to load correctly (musl/glibc mismatch otherwise).
FROM node:20-bookworm-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY src ./src

# ---- Runtime stage ----
FROM gcr.io/distroless/nodejs20-debian12:nonroot
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/src ./src
COPY package.json ./
EXPOSE 3000
CMD ["src/index.js"]
