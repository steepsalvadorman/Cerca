use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::features::job::application::TechnicianJobsOutput;
use crate::features::job::domain::{JobOffer, JobRequest};

#[derive(Serialize)]
pub struct JobRequestResponse {
    pub id: Uuid,
    pub client_id: Uuid,
    pub technician_profile_id: Option<i32>,
    pub tech_team_id: Option<i32>,
    pub job_kind: String,
    pub status: String,
    pub timeline_step: i32,
    pub fee_type: String,
    pub fee_amount: i32,
    pub fee_paid: bool,
    pub payment_method: Option<String>,
    pub payment_done: bool,
    pub mobility_included: bool,
    pub agreed_price: Option<i32>,
    pub rating: Option<i32>,
    pub title: Option<String>,
    pub address: Option<String>,
    pub comment: Option<String>,
    pub created_at: String,
}

impl From<JobRequest> for JobRequestResponse {
    fn from(j: JobRequest) -> Self {
        Self {
            id: j.id,
            client_id: j.client_id,
            technician_profile_id: j.technician_profile_id,
            tech_team_id: j.tech_team_id,
            job_kind: j.job_kind,
            status: j.status.as_str().to_string(),
            timeline_step: j.timeline_step,
            fee_type: j.fee_type,
            fee_amount: j.fee_amount,
            fee_paid: j.fee_paid,
            payment_method: j.payment_method,
            payment_done: j.payment_done,
            mobility_included: j.mobility_included,
            agreed_price: j.agreed_price,
            rating: j.rating,
            title: j.title,
            address: j.address,
            comment: j.comment,
            created_at: j.created_at.to_rfc3339(),
        }
    }
}

#[derive(Deserialize)]
pub struct CreateJobRequest {
    pub technician_profile_id: Option<i32>,
    pub tech_team_id: Option<i32>,
    pub job_kind: String, // "direct", "bidding", "project"
    pub title: Option<String>,
    pub address: Option<String>,
    pub mobility_included: Option<bool>,
}

#[derive(Deserialize)]
pub struct PayFeeRequest {
    pub payment_method: String,
}

#[derive(Deserialize)]
pub struct RateJobRequest {
    pub rating: i32,
    pub comment: Option<String>,
}

#[derive(Serialize)]
pub struct JobOfferResponse {
    pub id: i32,
    pub job_request_id: Uuid,
    pub technician_profile_id: i32,
    pub price: i32,
    pub eta: String,
    pub name: String,
    pub mono: String,
    pub oficio: String,
    pub rating: f64,
    pub verified: bool,
}

impl From<JobOffer> for JobOfferResponse {
    fn from(o: JobOffer) -> Self {
        Self {
            id: o.id,
            job_request_id: o.job_request_id,
            technician_profile_id: o.technician_profile_id,
            price: o.price,
            eta: o.eta,
            name: o.name,
            mono: o.mono,
            oficio: o.oficio,
            rating: o.rating,
            verified: o.verified,
        }
    }
}

#[derive(Deserialize)]
pub struct SubmitOfferRequest {
    pub price: i32,
    pub eta: String,
}

#[derive(Deserialize)]
pub struct ChooseOfferRequest {
    pub offer_id: i32,
}

#[derive(Serialize)]
pub struct TechnicianJobsResponse {
    pub assigned: Vec<JobRequestResponse>,
    pub open_for_bid: Vec<JobRequestResponse>,
}

impl From<TechnicianJobsOutput> for TechnicianJobsResponse {
    fn from(o: TechnicianJobsOutput) -> Self {
        Self {
            assigned: o.assigned.into_iter().map(Into::into).collect(),
            open_for_bid: o.open_for_bid.into_iter().map(Into::into).collect(),
        }
    }
}
