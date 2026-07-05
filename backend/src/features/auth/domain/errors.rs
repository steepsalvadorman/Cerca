use thiserror::Error;

/// Domain-level failures for the auth feature. Interfaces map these to
/// HTTP status codes; nothing in here knows about HTTP.
#[derive(Debug, Error)]
pub enum AuthError {
    #[error("that email is already registered")]
    EmailAlreadyExists,
    #[error("invalid email or password")]
    InvalidCredentials,
    #[error("invalid email address")]
    InvalidEmail,
    #[error("role must be 'client' or 'technician'")]
    InvalidRole,
    #[error("password must be at least 8 characters")]
    WeakPassword,
    #[error("could not process the password")]
    Hashing,
    #[error("could not issue a session token")]
    Token,
    #[error("unexpected repository failure: {0}")]
    Repository(String),
}
