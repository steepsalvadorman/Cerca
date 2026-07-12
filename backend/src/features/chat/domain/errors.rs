use thiserror::Error;

#[derive(Debug, Error, Clone)]
pub enum ChatError {
    #[error("unauthorized chat access")]
    Unauthorized,

    #[error("database error: {0}")]
    Repository(String),
}
