use std::sync::Arc;
use uuid::Uuid;

use crate::features::auth::domain::{AuthError, User, UserRepository};

/// Use case backing `GET /me`: resolve the authenticated user's full
/// profile from the id the JWT middleware already verified.
pub struct GetCurrentUserUseCase {
    repository: Arc<dyn UserRepository>,
}

impl GetCurrentUserUseCase {
    pub fn new(repository: Arc<dyn UserRepository>) -> Self {
        Self { repository }
    }

    pub async fn execute(&self, user_id: Uuid) -> Result<User, AuthError> {
        self.repository
            .find_by_id(user_id)
            .await?
            .ok_or(AuthError::InvalidCredentials)
    }
}
