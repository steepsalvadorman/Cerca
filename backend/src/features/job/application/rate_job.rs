use std::sync::Arc;
use uuid::Uuid;

use crate::features::job::domain::{JobError, JobRepository};

pub struct RateJobInput {
    pub job_request_id: Uuid,
    pub client_id: Uuid,
    pub rating: i32,
    pub comment: Option<String>,
}

pub struct RateJobUseCase {
    job_repo: Arc<dyn JobRepository>,
}

impl RateJobUseCase {
    pub fn new(job_repo: Arc<dyn JobRepository>) -> Self {
        Self { job_repo }
    }

    pub async fn execute(&self, input: RateJobInput) -> Result<(), JobError> {
        let mut job = self.job_repo
            .find_job_request_by_id(input.job_request_id)
            .await?
            .ok_or(JobError::JobNotFound)?;

        if job.client_id != input.client_id {
            return Err(JobError::Unauthorized);
        }

        job.rate(input.rating, input.comment)?;

        self.job_repo.save_job_request(&job).await?;
        Ok(())
    }
}
