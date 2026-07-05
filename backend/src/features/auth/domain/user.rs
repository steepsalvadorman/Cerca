use chrono::{DateTime, Utc};
use uuid::Uuid;

use super::value_objects::{Email, PasswordHash, Role};

/// The `User` aggregate root for the auth feature: identity plus the
/// invariants around it (always has a valid email, a role, a hash —
/// never a bare plaintext password).
#[derive(Debug, Clone)]
pub struct User {
    pub id: Uuid,
    pub email: Email,
    pub name: String,
    pub role: Role,
    pub password_hash: PasswordHash,
    pub created_at: DateTime<Utc>,
}

impl User {
    /// Registers a brand-new user. Existing users are reconstructed by
    /// infrastructure (from a DB row), never through this constructor.
    pub fn register(email: Email, name: String, role: Role, password_hash: PasswordHash) -> Self {
        Self {
            id: Uuid::new_v4(),
            email,
            name,
            role,
            password_hash,
            created_at: Utc::now(),
        }
    }
}
