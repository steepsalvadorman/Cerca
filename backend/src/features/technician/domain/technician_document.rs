use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum DocStatus {
    Uploaded,
    Pending,
}

impl DocStatus {
    pub fn as_str(&self) -> &'static str {
        match self {
            DocStatus::Uploaded => "uploaded",
            DocStatus::Pending => "pending",
        }
    }

    pub fn parse(raw: &str) -> Result<Self, String> {
        match raw {
            "uploaded" => Ok(DocStatus::Uploaded),
            "pending" => Ok(DocStatus::Pending),
            _ => Err(format!("invalid document status: {raw}")),
        }
    }
}

// id/technician_profile_id are populated from the DB row but not read yet —
// document_key is the only field the current handlers serialize back.
#[allow(dead_code)]
#[derive(Debug, Clone)]
pub struct TechnicianDocument {
    pub id: Uuid,
    pub technician_profile_id: i32,
    pub document_key: String,
    pub status: DocStatus,
}
