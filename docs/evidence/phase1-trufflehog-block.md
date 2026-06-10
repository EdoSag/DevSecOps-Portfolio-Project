# Phase 1 — TruffleHog Pre-Commit Hook Blocks Hardcoded AWS Credentials

Command: `git commit -m "Initial scaffold: vulnerable demo app, pre-commit config"`

```
TruffleHog (secret scan).................................................Failed
- hook id: trufflehog
- exit code: 183

🐷🔑🐷  TruffleHog. Unearth your secrets. 🐷🔑🐷

Found unverified result 🐷🔑❓
Detector Type: AWS
Decoder Type: PLAIN
Raw result: AKIA[REDACTED-IN-DOCS]
Resource_type: Access key
File: app\src\config.js
Line: 4

unverified_secrets: 2 (one is the same finding inside .git/objects, expected for a staged blob)
```

**Source of the finding** — `app/src/config.js`:
```js
module.exports = {
  jwtSecret: 'dev-secret-change-me',
  // FIXME: placeholder credentials committed for local testing - remove before prod
  awsAccessKeyId: 'AKIA[REDACTED-IN-DOCS]',
  awsSecretAccessKey: '[REDACTED-IN-DOCS]',
};
```

The commit was rejected before it ever reached the repository. Remediation: move both
values to environment variables (`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`), provide
a `.env.example` placeholder, and re-run the commit — TruffleHog passes.
