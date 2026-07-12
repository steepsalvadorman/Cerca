use chrono::{DateTime, Utc};
use uuid::Uuid;

#[derive(Debug, Clone)]
pub struct TechnicianLocation {
    pub job_request_id: Uuid,
    pub latitude: f64,
    pub longitude: f64,
    pub updated_at: DateTime<Utc>,
}

impl TechnicianLocation {
    pub fn new(job_request_id: Uuid, latitude: f64, longitude: f64) -> Self {
        Self {
            job_request_id,
            latitude,
            longitude,
            updated_at: Utc::now(),
        }
    }
}
