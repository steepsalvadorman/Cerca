use chrono::{DateTime, Utc};
use uuid::Uuid;

#[derive(Debug, Clone)]
pub struct ChatMessage {
    pub id: Uuid,
    pub job_request_id: Uuid,
    pub sender_id: Uuid,
    pub sender_role: String, // "client" | "technician"
    pub text: String,
    pub created_at: DateTime<Utc>,
}

impl ChatMessage {
    pub fn new(job_request_id: Uuid, sender_id: Uuid, sender_role: String, text: String) -> Self {
        Self {
            id: Uuid::new_v4(),
            job_request_id,
            sender_id,
            sender_role,
            text,
            created_at: Utc::now(),
        }
    }
}
