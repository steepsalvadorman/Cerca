use std::sync::Arc;
use uuid::Uuid;

use crate::features::job::domain::{JobError, JobRepository, JobStatus};

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

        // Choosing is a one-time decision taken while the job is still
        // open. Without this, a client could swap the technician on a job
        // that is already under way — or already finished and rated.
        if job.status != JobStatus::Pending {
            return Err(JobError::InvalidStatusTransition);
        }
        if job.technician_profile_id.is_some() {
            return Err(JobError::InvalidStatusTransition);
        }

        let offer = self.job_repo
            .find_offer_by_id(input.offer_id)
            .await?
            .ok_or(JobError::OfferNotFound)?;

        if offer.job_request_id != input.job_request_id {
            return Err(JobError::InvalidStatusTransition);
        }

        // The job starts with its technician and price, and the winner
        // pays one credit — atomically, so a job never starts unpaid nor
        // is a credit taken for a job that did not start. Submitting the
        // offer already required a free credit, so the client is never
        // refused the offer they picked.
        job.assign_winner(offer.technician_profile_id, offer.price)?;
        self.job_repo.assign_winner(&job).await?;
        Ok(())
    }
}
