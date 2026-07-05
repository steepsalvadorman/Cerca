mod config;
mod db;
mod features;
mod routes;
mod shared;
mod state;

use std::sync::Arc;

use config::AppConfig;
use features::auth::infrastructure::{Argon2PasswordHasher, JwtTokenService, PostgresUserRepository};
use state::AppState;

#[tokio::main]
async fn main() {
    // Ignore the error: in Docker/production env vars are set directly
    // and there is no .env file to load.
    let _ = dotenvy::dotenv();

    tracing_subscriber::fmt()
        .with_env_filter(
            std::env::var("RUST_LOG").unwrap_or_else(|_| "backend=debug,tower_http=debug".into()),
        )
        .init();

    let config = AppConfig::from_env();

    let pool = db::create_pool(&config.database_url)
        .await
        .expect("failed to connect to Postgres — is it running? see backend/docker-compose.yml");

    sqlx::migrate!("./migrations")
        .run(&pool)
        .await
        .expect("failed to run database migrations");

    let state = AppState {
        user_repository: Arc::new(PostgresUserRepository::new(pool)),
        password_hasher: Arc::new(Argon2PasswordHasher),
        token_service: Arc::new(JwtTokenService::new(&config.jwt_secret)),
    };

    let app = routes::app_router(state);

    let listener = tokio::net::TcpListener::bind(("0.0.0.0", config.port))
        .await
        .expect("failed to bind to port");

    tracing::info!("listening on port {}", config.port);

    axum::serve(listener, app).await.expect("server error");
}
