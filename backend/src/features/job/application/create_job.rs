use std::sync::Arc;
use uuid::Uuid;

use crate::features::job::domain::{JobError, JobRequest, JobRepository};

pub struct CreateJobInput {
    pub client_id: Uuid,
    pub technician_profile_id: Option<i32>,
    pub tech_team_id: Option<i32>,
    pub job_kind: String, // "direct", "bidding", "project"
    pub title: Option<String>,
    pub address: Option<String>,
    pub mobility_included: Option<bool>,
}

pub struct CreateJobUseCase {
    job_repo: Arc<dyn JobRepository>,
}

impl CreateJobUseCase {
    pub fn new(job_repo: Arc<dyn JobRepository>) -> Self {
        Self { job_repo }
    }

    pub async fn execute(&self, input: CreateJobInput) -> Result<JobRequest, JobError> {
        // Validate job kind
        if input.job_kind != "direct" && input.job_kind != "bidding" && input.job_kind != "project" {
            return Err(JobError::InvalidStatusTransition);
        }

        // fee type matches the job kind
        let fee_type = input.job_kind.clone();

        let job = JobRequest::new(
            input.client_id,
            input.technician_profile_id,
            input.tech_team_id,
            input.job_kind,
            fee_type,
            input.title,
            input.address,
            input.mobility_included.unwrap_or(true),
        );

        self.job_repo.create_job_request(&job).await?;
        Ok(job)
    }
}
