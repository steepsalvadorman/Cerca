use std::sync::Arc;
use uuid::Uuid;

use crate::features::job::domain::{JobError, JobRepository};

pub struct ChooseOfferInput {
    pub job_request_id: Uuid,
    pub client_id: Uuid,
    pub offer_id: i32,
}

pub struct ChooseOfferUseCase {
    job_repo: Arc<dyn JobRepository>,
}

impl ChooseOfferUseCase {
    pub fn new(job_repo: Arc<dyn JobRepository>) -> Self {
        Self { job_repo }
    }

    pub async fn execute(&self, input: ChooseOfferInput) -> Result<(), JobError> {
        let mut job = self.job_repo
            .find_job_request_by_id(input.job_request_id)
            .await?
            .ok_or(JobError::JobNotFound)?;

        if job.client_id != input.client_id {
            return Err(JobError::Unauthorized);
        }

        let offer = self.job_repo
            .find_offer_by_id(input.offer_id)
            .await?
            .ok_or(JobError::OfferNotFound)?;

        if offer.job_request_id != input.job_request_id {
            return Err(JobError::InvalidStatusTransition);
        }

        // Set the technician profile ID on the job
        job.technician_profile_id = Some(offer.technician_profile_id);
        
        self.job_repo.save_job_request(&job).await?;
        Ok(())
    }
}
