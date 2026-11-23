use std::env;

use crate::features::technician::infrastructure::S3Config;

pub struct AppConfig {
    pub database_url: String,
    pub jwt_secret: String,
    pub port: u16,
    /// `APP_ENV`, lowercased and trimmed. `"production"` switches on the
    /// deployment guards in `main` — today, refusing to boot while a
    /// publicly-known demo password hash is still in the database.
    pub environment: String,
    /// Origins allowed to call the API via CORS (e.g. a future admin web
    /// panel). Defaults to empty — the app is mobile-only today, and
    /// mobile clients aren't subject to CORS, so "no origins configured"
    /// is the safe default rather than an error to `.expect()` on.
    pub cors_allowed_origins: Vec<String>,
    /// `None` until the document bucket is provisioned. Uploads then
    /// answer 503 instead of the server refusing to start — every other
    /// feature works without it.
    pub storage: Option<S3Config>,
    /// OAuth client ids accepted in the `aud` claim of a Google ID
    /// token — the Android, iOS and web clients of this project. Empty
    /// until they are created in Google Cloud Console, and then
    /// `/auth/google` answers 503 rather than accepting tokens minted
    /// for some other app.
    pub google_client_ids: Vec<String>,
    /// How payments are collected. `"fake"` simulates success (dev/test
    /// only — `main` refuses it in production); `"culqi"` charges for
    /// real and needs both keys below. Anything else answers 503.
    pub payments_mode: String,
    /// Culqi secret key (`sk_test_…` / `sk_live_…`). Server-side only.
    pub culqi_secret_key: Option<String>,
    /// Culqi public key (`pk_…`), handed to the app to create tokens.
    pub culqi_public_key: Option<String>,
    /// Reverse proxies in front of the server that append to
    /// X-Forwarded-For (Render: 1). 0 = trust no forwarded header.
    pub trusted_proxy_hops: usize,
}

impl AppConfig {
    pub fn from_env() -> Self {
        Self {
            database_url: env::var("DATABASE_URL")
                .expect("DATABASE_URL must be set (see backend/.env.example)"),
            jwt_secret: env::var("JWT_SECRET")
                .expect("JWT_SECRET must be set (see backend/.env.example)"),
            port: env::var("PORT")
                .ok()
                .and_then(|p| p.parse().ok())
                .unwrap_or(8080),
            environment: env::var("APP_ENV")
                .unwrap_or_default()
                .trim()
                .to_lowercase(),
            cors_allowed_origins: env::var("CORS_ALLOWED_ORIGINS")
                .unwrap_or_default()
                .split(',')
                .map(|s| s.trim().to_string())
                .filter(|s| !s.is_empty())
                .collect(),
            storage: storage_from_env(),
            google_client_ids: env::var("GOOGLE_CLIENT_IDS")
                .unwrap_or_default()
                .split(',')
                .map(|s| s.trim().to_string())
                .filter(|s| !s.is_empty())
                .collect(),
            // Unset means payments are off (503), never simulated: a
            // forgotten variable must not hand out free credits.
            payments_mode: env::var("PAYMENTS_MODE")
                .unwrap_or_else(|_| "unconfigured".to_string())
                .trim()
                .to_lowercase(),
            culqi_secret_key: non_empty("CULQI_SECRET_KEY"),
            culqi_public_key: non_empty("CULQI_PUBLIC_KEY"),
            trusted_proxy_hops: non_empty("TRUSTED_PROXY_HOPS")
                .and_then(|v| v.parse().ok())
                .unwrap_or(0),
        }
    }

    /// True only for an explicit `APP_ENV=production`. Anything else —
    /// unset, `dev`, `staging` — is treated as not-production, so a
    /// misconfigured deploy fails open on *convenience* and never on the
    /// guards themselves (a missing `APP_ENV` cannot silence a security
    /// check unless it was also missing when the demo data was loaded).
    pub fn is_production(&self) -> bool {
        self.environment == "production"
    }
}

/// All the storage variables or none — a half-configured bucket would
/// fail at upload time with a signature error that says nothing useful.
/// Works with any S3-compatible provider (R2, Backblaze B2, Supabase
/// Storage, MinIO, AWS); only these values change.
fn storage_from_env() -> Option<S3Config> {
    Some(S3Config {
        endpoint: non_empty("S3_ENDPOINT")?,
        // R2 is region-less and expects the literal `auto`; other
        // providers need their real region.
        region: non_empty("S3_REGION").unwrap_or_else(|| "auto".to_string()),
        access_key_id: non_empty("S3_ACCESS_KEY_ID")?,
        secret_access_key: non_empty("S3_SECRET_ACCESS_KEY")?,
        bucket: non_empty("S3_BUCKET")?,
    })
}

fn non_empty(key: &str) -> Option<String> {
    env::var(key).ok().map(|v| v.trim().to_string()).filter(|v| !v.is_empty())
}
