use std::sync::Arc;
use uuid::Uuid;

use crate::features::job::domain::{JobError, JobRepository};
use crate::features::technician::domain::TechnicianRepository;

use super::authorize_job_access;

pub struct AdvanceProgressUseCase {
    job_repo: Arc<dyn JobRepository>,
    technician_repo: Arc<dyn TechnicianRepository>,
}

impl AdvanceProgressUseCase {
    pub fn new(job_repo: Arc<dyn JobRepository>, technician_repo: Arc<dyn TechnicianRepository>) -> Self {
        Self { job_repo, technician_repo }
    }

    pub async fn execute(&self, job_request_id: Uuid, caller_id: Uuid) -> Result<(), JobError> {
        let mut job = self.job_repo
            .find_job_request_by_id(job_request_id)
            .await?
            .ok_or(JobError::JobNotFound)?;

        authorize_job_access(&job, caller_id, &self.technician_repo).await?;

        job.advance_timeline()?;

        self.job_repo.save_job_request(&job).await?;
        Ok(())
    }
}
