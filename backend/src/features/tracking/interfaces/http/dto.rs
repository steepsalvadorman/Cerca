use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::features::tracking::domain::TechnicianLocation;

#[derive(Serialize)]
pub struct LocationResponse {
    pub job_request_id: Uuid,
    pub latitude: f64,
    pub longitude: f64,
    pub updated_at: String,
}

impl From<TechnicianLocation> for LocationResponse {
    fn from(l: TechnicianLocation) -> Self {
        Self {
            job_request_id: l.job_request_id,
            latitude: l.latitude,
            longitude: l.longitude,
            updated_at: l.updated_at.to_rfc3339(),
        }
    }
}

#[derive(Deserialize)]
pub struct UpdateLocationRequest {
    pub latitude: f64,
    pub longitude: f64,
}
