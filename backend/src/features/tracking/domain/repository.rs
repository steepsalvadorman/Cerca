use async_trait::async_trait;
use uuid::Uuid;

use super::errors::TrackingError;
use super::location::TechnicianLocation;

#[async_trait]
pub trait TrackingRepository: Send + Sync {
    async fn update_location(&self, location: &TechnicianLocation) -> Result<(), TrackingError>;
    async fn find_location_by_job_id(&self, job_request_id: Uuid) -> Result<Option<TechnicianLocation>, TrackingError>;
}
