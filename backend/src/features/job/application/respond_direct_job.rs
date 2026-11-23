use std::sync::Arc;

use uuid::Uuid;

use crate::features::job::domain::{JobError, JobRepository};
use crate::features::technician::domain::TechnicianRepository;

/// The technician named in a direct hire answers it. Accepting starts the
/// job and costs one credit (like winning an auction); declining cancels
/// it. Before audit run-1 a direct job started Active the moment a client
/// created it: technicians could neither refuse unsolicited work nor stop
/// a second account of their own from minting reviews at no cost.
pub struct RespondDirectJobUseCase {
    job_repo: Arc<dyn JobRepository>,
    technician_repo: Arc<dyn TechnicianRepository>,
}

impl RespondDirectJobUseCase {
    pub fn new(job_repo: Arc<dyn JobRepository>, technician_repo: Arc<dyn TechnicianRepository>) -> Self {
        Self { job_repo, technician_repo }
    }

    async fn profile_id(&self, technician_user_id: Uuid) -> Result<i32, JobError> {
        Ok(self
            .technician_repo
            .find_profile_by_user_id(technician_user_id)
            .await
            .map_err(|e| JobError::Repository(e.to_string()))?
            .ok_or(JobError::Unauthorized)?
            .id)
    }

    pub async fn accept(&self, job_request_id: Uuid, technician_user_id: Uuid) -> Result<(), JobError> {
        let profile_id = self.profile_id(technician_user_id).await?;
        let mut job = self
            .job_repo
            .find_job_request_by_id(job_request_id)
            .await?
            .ok_or(JobError::JobNotFound)?;
        job.accept_direct(profile_id)?;
        self.job_repo.accept_direct_job(&job).await
    }

    pub async fn decline(&self, job_request_id: Uuid, technician_user_id: Uuid) -> Result<(), JobError> {
        let profile_id = self.profile_id(technician_user_id).await?;
        let mut job = self
            .job_repo
            .find_job_request_by_id(job_request_id)
            .await?
            .ok_or(JobError::JobNotFound)?;
        job.decline_direct(profile_id, technician_user_id)?;
        // Nothing was charged before acceptance, so nothing to refund.
        self.job_repo.cancel_job(&job, false).await
    }
}
