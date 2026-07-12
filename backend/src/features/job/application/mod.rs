pub mod advance_progress;
pub mod choose_offer;
pub mod create_job;
pub mod pay_fee;
pub mod rate_job;
pub mod submit_offer;

use std::sync::Arc;
use uuid::Uuid;

pub use advance_progress::AdvanceProgressUseCase;
pub use choose_offer::{ChooseOfferInput, ChooseOfferUseCase};
pub use create_job::{CreateJobInput, CreateJobUseCase};
pub use pay_fee::{PayFeeInput, PayFeeUseCase};
pub use rate_job::{RateJobInput, RateJobUseCase};
pub use submit_offer::{SubmitOfferInput, SubmitOfferUseCase};

use crate::features::job::domain::{JobError, JobOffer, JobRequest, JobRepository};
use crate::features::technician::domain::TechnicianRepository;

/// Shared ownership check for every handler that reads or mutates a single
/// job: the caller must be either the job's client, or the technician
/// currently assigned to it. Used by `Get`/`GetJobOffers`/`AdvanceProgress`
/// use cases, which (unlike pay/rate/choose-offer) previously had no
/// authorization check at all.
pub(crate) async fn authorize_job_access(
    job: &JobRequest,
    caller_id: Uuid,
    technician_repo: &Arc<dyn TechnicianRepository>,
) -> Result<(), JobError> {
    if job.client_id == caller_id {
        return Ok(());
    }

    let is_assigned_technician = match job.technician_profile_id {
        Some(assigned_profile_id) => technician_repo
            .find_profile_by_user_id(caller_id)
            .await
            .map_err(|e| JobError::Repository(e.to_string()))?
            .is_some_and(|profile| profile.id == assigned_profile_id),
        None => false,
    };

    if is_assigned_technician {
        Ok(())
    } else {
        Err(JobError::Unauthorized)
    }
}

pub struct GetJobRequestUseCase {
    job_repo: Arc<dyn JobRepository>,
    technician_repo: Arc<dyn TechnicianRepository>,
}

impl GetJobRequestUseCase {
    pub fn new(job_repo: Arc<dyn JobRepository>, technician_repo: Arc<dyn TechnicianRepository>) -> Self {
        Self { job_repo, technician_repo }
    }

    pub async fn execute(&self, id: Uuid, caller_id: Uuid) -> Result<Option<JobRequest>, JobError> {
        let job = self.job_repo.find_job_request_by_id(id).await?;
        if let Some(job) = &job {
            authorize_job_access(job, caller_id, &self.technician_repo).await?;
        }
        Ok(job)
    }
}

pub struct GetJobOffersUseCase {
    job_repo: Arc<dyn JobRepository>,
    technician_repo: Arc<dyn TechnicianRepository>,
}

impl GetJobOffersUseCase {
    pub fn new(job_repo: Arc<dyn JobRepository>, technician_repo: Arc<dyn TechnicianRepository>) -> Self {
        Self { job_repo, technician_repo }
    }

    pub async fn execute(&self, job_request_id: Uuid, caller_id: Uuid) -> Result<Vec<JobOffer>, JobError> {
        let job = self.job_repo
            .find_job_request_by_id(job_request_id)
            .await?
            .ok_or(JobError::JobNotFound)?;
        authorize_job_access(&job, caller_id, &self.technician_repo).await?;

        self.job_repo.find_offers_by_job_id(job_request_id).await
    }
}

pub struct GetClientHistoryUseCase {
    job_repo: Arc<dyn JobRepository>,
}

impl GetClientHistoryUseCase {
    pub fn new(job_repo: Arc<dyn JobRepository>) -> Self {
        Self { job_repo }
    }

    pub async fn execute(&self, client_id: Uuid) -> Result<Vec<JobRequest>, JobError> {
        self.job_repo.find_client_history(client_id).await
    }
}
