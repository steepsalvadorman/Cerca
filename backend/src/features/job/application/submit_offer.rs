use std::sync::Arc;
use uuid::Uuid;

use crate::features::job::domain::{JobError, JobRepository};
use crate::features::technician::domain::TechnicianRepository;

pub struct SubmitOfferInput {
    pub job_request_id: Uuid,
    pub technician_user_id: Uuid,
    pub price: i32,
    pub eta: String,
}

pub struct SubmitOfferUseCase {
    job_repo: Arc<dyn JobRepository>,
    technician_repo: Arc<dyn TechnicianRepository>,
}

impl SubmitOfferUseCase {
    pub fn new(
        job_repo: Arc<dyn JobRepository>,
        technician_repo: Arc<dyn TechnicianRepository>,
    ) -> Self {
        Self { job_repo, technician_repo }
    }

    pub async fn execute(&self, input: SubmitOfferInput) -> Result<(), JobError> {
        let profile = self.technician_repo
            .find_profile_by_user_id(input.technician_user_id)
            .await
            .map_err(|e| JobError::Repository(e.to_string()))?
            .ok_or(JobError::Unauthorized)?; // Only registered technicians can bid

        self.job_repo
            .add_job_offer(input.job_request_id, profile.id, input.price, input.eta)
            .await?;

        Ok(())
    }
}
