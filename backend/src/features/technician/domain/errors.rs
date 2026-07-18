use thiserror::Error;

// TeamNotFound/DocumentNotFound aren't constructed yet — reserved for
// find_team_by_id and document lookups that don't check existence yet.
#[allow(dead_code)]
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
