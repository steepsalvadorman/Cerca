use thiserror::Error;

#[derive(Debug, Error, Clone)]
pub enum JobError {
    #[error("job request not found")]
    JobNotFound,

    #[error("job offer not found")]
    OfferNotFound,

    #[error("invalid job status or transition")]
    InvalidStatusTransition,

    #[error("unauthorized operation")]
    Unauthorized,

    #[error("database error: {0}")]
    Repository(String),
}
