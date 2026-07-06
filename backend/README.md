# Cerca backend

Rust (Axum + Postgres/sqlx + argon2 + JWT) auth backend. See `src/features/auth/`
for the domain/application/infrastructure/interfaces layers.

## Local development

1. Start Postgres:
   ```sh
   docker compose up -d postgres
   ```
2. Copy the env template (only needed once):
   ```sh
   cp .env.example .env
   ```
3. Run the server (migrations run automatically on startup):
   ```sh
   cargo run
   ```
   For auto-reload on file changes instead:
   ```sh
   cargo install cargo-watch   # once
   cargo watch -x run
   ```

The server listens on `http://localhost:8080` (`PORT` in `.env`). Health check:
`curl http://localhost:8080/health`.

## Full-stack local dev (with the Flutter app)

With the backend running as above, point the app at it — `10.0.2.2` is the
Android emulator's alias for your machine's `localhost`:
```sh
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```
Desktop/iOS simulator/web instead use `http://localhost:8080`; a physical
device needs your machine's LAN IP.

## Environments

- **`develop` branch**: local-only. Pushing here only runs sanity checks
  (`cargo check`, `flutter analyze`) — nothing gets deployed.
- **`main` branch**: production. Pushing here deploys this backend to
  Fly.io (`.github/workflows/backend-deploy.yml`) and builds+distributes
  the Android app pointed at the deployed backend
  (`.github/workflows/android-distribute.yml`).

## Fully containerized run

`docker compose up --build` runs Postgres and the backend together, no
local Rust toolchain required.
