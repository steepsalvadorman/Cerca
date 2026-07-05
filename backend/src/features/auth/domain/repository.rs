use async_trait::async_trait;
use uuid::Uuid;

use super::errors::AuthError;
use super::user::User;
use super::value_objects::Email;

/// Port for `User` persistence, owned by the domain (classic DDD
/// repository pattern) and implemented by an infrastructure adapter.
#[async_trait]
pub trait UserRepository: Send + Sync {
    async fn insert(&self, user: &User) -> Result<(), AuthError>;
    async fn find_by_email(&self, email: &Email) -> Result<Option<User>, AuthError>;
    async fn find_by_id(&self, id: Uuid) -> Result<Option<User>, AuthError>;
}
