use std::sync::Arc;
use uuid::Uuid;

use crate::features::job::domain::{JobError, JobRepository, JobRequest};
use crate::features::technician::domain::TechnicianRepository;

pub struct TechnicianJobsOutput {
    pub assigned: Vec<JobRequest>,
    pub open_for_bid: Vec<JobRequest>,
}

pub struct GetTechnicianJobsUseCase {
    job_repo: Arc<dyn JobRepository>,
    technician_repo: Arc<dyn TechnicianRepository>,
}

impl GetTechnicianJobsUseCase {
    pub fn new(job_repo: Arc<dyn JobRepository>, technician_repo: Arc<dyn TechnicianRepository>) -> Self {
        Self { job_repo, technician_repo }
    }

    pub async fn execute(&self, caller_id: Uuid) -> Result<TechnicianJobsOutput, JobError> {
        let profile = self
            .technician_repo
            .find_profile_by_user_id(caller_id)
            .await
            .map_err(|e| JobError::Repository(e.to_string()))?
            .ok_or(JobError::Unauthorized)?; // Only registered technicians have a job inbox

        let assigned = self.job_repo.find_assigned_jobs(profile.id).await?;
        let open_for_bid = self.job_repo.find_open_bidding_jobs(profile.id).await?;

        Ok(TechnicianJobsOutput { assigned, open_for_bid })
    }
}
