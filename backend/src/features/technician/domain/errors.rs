use thiserror::Error;

#[derive(Debug, Error, Clone)]
pub enum TechnicianError {
    #[error("technician profile not found")]
    TechnicianNotFound,

    #[error("tech team not found")]
    TeamNotFound,

    #[error("document not found")]
    DocumentNotFound,

    #[error("invalid document status: {0}")]
    InvalidDocumentStatus(String),

    #[error("database error: {0}")]
    Repository(String),
}
