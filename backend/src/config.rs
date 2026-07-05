use std::env;

pub struct AppConfig {
    pub database_url: String,
    pub jwt_secret: String,
    pub port: u16,
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
        }
    }
}
