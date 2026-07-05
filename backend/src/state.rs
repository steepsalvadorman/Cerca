use std::sync::Arc;

use crate::features::auth::application::{PasswordHasher, TokenService};
use crate::features::auth::domain::UserRepository;

/// Shared application state injected into every handler via axum's
/// `State` extractor. Holds ports as trait objects so infrastructure
/// (Postgres, argon2, JWT) stays swappable behind the interfaces
/// defined in `features::auth::{domain, application}`.
#[derive(Clone)]
pub struct AppState {
    pub user_repository: Arc<dyn UserRepository>,
    pub password_hasher: Arc<dyn PasswordHasher>,
    pub token_service: Arc<dyn TokenService>,
}
