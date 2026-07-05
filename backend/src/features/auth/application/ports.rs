use uuid::Uuid;

use crate::features::auth::domain::Role;

/// Technical capability the use cases need — hashing is a delivery
/// detail (argon2 today), not a domain concept, so it lives as an
/// application-level port rather than on the `User` aggregate.
pub trait PasswordHasher: Send + Sync {
    fn hash(&self, plain: &str) -> Result<String, ()>;
    fn verify(&self, plain: &str, hash: &str) -> Result<bool, ()>;
}

pub struct TokenClaims {
    pub user_id: Uuid,
    pub role: Role,
}

/// Port for issuing/validating session tokens (JWT today).
pub trait TokenService: Send + Sync {
    fn issue(&self, user_id: Uuid, role: Role) -> Result<String, ()>;
    fn verify(&self, token: &str) -> Result<TokenClaims, ()>;
}
