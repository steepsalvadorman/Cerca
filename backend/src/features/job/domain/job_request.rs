use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

use super::errors::JobError;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum JobStatus {
    Pending,
    Active,
    Completed,
    Cancelled,
}

impl JobStatus {
    pub fn as_str(&self) -> &'static str {
        match self {
            JobStatus::Pending => "pending",
            JobStatus::Active => "active",
            JobStatus::Completed => "completed",
            JobStatus::Cancelled => "cancelled",
        }
    }

    pub fn parse(raw: &str) -> Result<Self, String> {
        match raw {
            "pending" => Ok(JobStatus::Pending),
            "active" => Ok(JobStatus::Active),
            "completed" => Ok(JobStatus::Completed),
            "cancelled" => Ok(JobStatus::Cancelled),
            _ => Err(format!("invalid job status: {raw}")),
        }
    }
}

/// The app-fee schedule (soles), keyed by `fee_type`. The single source of
/// truth for what a client is actually charged — the frontend used to keep
/// its own copy of these amounts purely for display, with nothing tying it
/// to what the backend would accept.
///
/// Every kind is free for the client: Cerca charges the *technician*, one
/// prepaid credit when a client picks their offer (migration 0016,
/// `features::credits`). The per-auction S/ 4 the client used to pay lost
/// a quarter or more to the PSP's fixed fee and needed a receipt per S/ 4.
/// Kept as a function so a paid kind can come back without a schema change.
fn fee_amount_for(_fee_type: &str) -> i32 {
    0
}

#[derive(Debug, Clone)]
pub struct JobRequest {
    pub id: Uuid,
    pub client_id: Uuid,
    pub technician_profile_id: Option<i32>,
    pub tech_team_id: Option<i32>,
    pub job_kind: String, // "direct", "bidding", "project"
    pub status: JobStatus,
    pub timeline_step: i32, // 0: Confirmado, 1: En camino, 2: En el trabajo, 3: Finalizado
    pub fee_type: String, // "direct", "bidding", "project"
    pub fee_amount: i32,
    /// Cerca's app fee is settled: either paid, or there was nothing to
    /// charge (a free `fee_type` is born with this already `true`).
    pub fee_paid: bool,
    pub payment_method: Option<String>,
    /// A payment transaction actually happened. A free job is `fee_paid`
    /// without `payment_done`, and that is correct, not a divergence.
    pub payment_done: bool,
    pub mobility_included: bool,
    pub agreed_price: Option<i32>,
    pub rating: Option<i32>,
    pub title: Option<String>,
    pub address: Option<String>,
    pub comment: Option<String>,
    /// Set exactly when `status` is `Cancelled`; a CHECK constraint in
    /// migration 0012 enforces that correspondence.
    pub cancelled_at: Option<DateTime<Utc>>,
    /// Who ended it. Kept separate from the status because "the client
    /// withdrew before anyone bid" and "the technician walked away
    /// mid-job" are the same status and very different facts.
    pub cancelled_by: Option<Uuid>,
    pub cancellation_reason: Option<String>,
    /// Optimistic-concurrency counter (migration 0013). Incremented on the
    /// way out of `save_job_request`, and compared so a second writer
    /// whose read is stale matches no rows instead of overwriting the
    /// first (GAP-07).
    pub version: i32,
    pub created_at: DateTime<Utc>,
}

impl JobRequest {
    pub fn new(
        client_id: Uuid,
        technician_profile_id: Option<i32>,
        tech_team_id: Option<i32>,
        job_kind: String,
        fee_type: String,
        title: Option<String>,
        address: Option<String>,
        mobility_included: bool,
    ) -> Self {
        let fee_amount = fee_amount_for(&fee_type);
        let is_free = fee_amount == 0;
        // An auction stays open until the client picks an offer, and a
        // direct hire waits for the named technician to accept it (they
        // pay a credit on acceptance). Before audit run-1 a direct job was
        // born Active: any client could assign work, chat and reviews to
        // any technician without their consent.
        let starts_pending = job_kind == "bidding" || job_kind == "direct" || !is_free;
        Self {
            id: Uuid::new_v4(),
            client_id,
            technician_profile_id,
            tech_team_id,
            job_kind,
            status: if starts_pending { JobStatus::Pending } else { JobStatus::Active },
            timeline_step: 0,
            fee_amount,
            fee_type,
            fee_paid: is_free,
            payment_method: None,
            payment_done: false,
            mobility_included,
            agreed_price: None,
            rating: None,
            title,
            address,
            comment: None,
            cancelled_at: None,
            cancelled_by: None,
            cancellation_reason: None,
            version: 0,
            created_at: Utc::now(),
        }
    }

    /// Records the bidding fee as paid and starts the job. Free jobs are
    /// already active, so retries are harmless no-ops.
    ///
    /// Idempotent on purpose: a retried request (flaky network, an
    /// impatient double tap) must not be an error, but it must also not
    /// replay the state change — without the early return, paying twice
    /// on a finished job would reset it to `Active` at step 0, undoing
    /// a completed job.
    ///
    /// The terminal check comes *first*, and that ordering matters: while
    /// the early return ran before any status validation, a *free* job
    /// (already `fee_paid`) that had been cancelled or completed answered
    /// `Ok` here, so `POST /pay` reported success on a job nobody could
    /// pay for. Reachable the moment cancellation existed (GAP-12).
    pub fn pay_fee(&mut self) -> Result<(), JobError> {
        if self.is_terminal() {
            return Err(JobError::InvalidStatusTransition);
        }
        if self.fee_paid {
            return Ok(());
        }
        if self.status != JobStatus::Pending {
            return Err(JobError::InvalidStatusTransition);
        }

        self.fee_paid = true;
        self.payment_done = true;
        self.status = JobStatus::Active;
        self.timeline_step = 0; // Confirmado
        Ok(())
    }

    /// The client picks the winning offer of an open auction: the job gets
    /// its technician and price and starts. One-time — a job under way, or
    /// one that already has a technician, cannot be reassigned.
    pub fn assign_winner(&mut self, technician_profile_id: i32, price: i32) -> Result<(), JobError> {
        if self.job_kind != "bidding" || self.status != JobStatus::Pending || self.technician_profile_id.is_some() {
            return Err(JobError::InvalidStatusTransition);
        }
        self.technician_profile_id = Some(technician_profile_id);
        self.agreed_price = Some(price);
        // The client owes nothing for an auction any more — the winner
        // pays a credit — so the fee is settled here even on an auction
        // created under the old per-auction fee.
        self.fee_paid = true;
        self.status = JobStatus::Active;
        self.timeline_step = 0; // Confirmado
        Ok(())
    }

    /// The named technician accepts a direct hire: the job starts.
    pub fn accept_direct(&mut self, technician_profile_id: i32) -> Result<(), JobError> {
        if self.job_kind != "direct" || self.status != JobStatus::Pending {
            return Err(JobError::InvalidStatusTransition);
        }
        if self.technician_profile_id != Some(technician_profile_id) {
            return Err(JobError::Unauthorized);
        }
        self.fee_paid = true;
        self.status = JobStatus::Active;
        self.timeline_step = 0; // Confirmado
        Ok(())
    }

    /// The named technician turns down a direct hire they never accepted.
    /// This is their way to remove unsolicited jobs from their inbox.
    pub fn decline_direct(&mut self, technician_profile_id: i32, by: Uuid) -> Result<(), JobError> {
        if self.job_kind != "direct" || self.status != JobStatus::Pending {
            return Err(JobError::InvalidStatusTransition);
        }
        if self.technician_profile_id != Some(technician_profile_id) {
            return Err(JobError::Unauthorized);
        }
        self.cancel(by, Some("Rechazado por el técnico".to_string()))
    }

    /// Whether a client cancelling now owes the technician their credit
    /// back: the technician paid one to start this job (auction win or
    /// direct acceptance) and no work has begun yet.
    pub fn refunds_credit_on_cancel(&self) -> bool {
        matches!(self.job_kind.as_str(), "bidding" | "direct")
            && self.status == JobStatus::Active
            && self.timeline_step == 0
            && self.technician_profile_id.is_some()
    }

    /// An open auction older than the TTL can no longer take offers or be
    /// won (see `credits::OPEN_AUCTION_TTL_DAYS`).
    pub fn is_expired_auction(&self, now: DateTime<Utc>, ttl_days: i32) -> bool {
        self.job_kind == "bidding"
            && self.status == JobStatus::Pending
            && self.created_at < now - chrono::Duration::days(ttl_days as i64)
    }

    pub fn advance_timeline(&mut self) -> Result<(), JobError> {
        if self.status != JobStatus::Active {
            return Err(JobError::InvalidStatusTransition);
        }
        if self.timeline_step < 3 {
            self.timeline_step += 1;
            if self.timeline_step == 3 {
                self.status = JobStatus::Completed;
            }
        }
        Ok(())
    }

    pub fn rate(&mut self, rating: i32, comment: Option<String>) -> Result<(), JobError> {
        if self.status != JobStatus::Completed {
            return Err(JobError::InvalidStatusTransition);
        }
        if self.rating.is_some() {
            return Err(JobError::InvalidStatusTransition);
        }
        if !(1..=5).contains(&rating) {
            return Err(JobError::InvalidStatusTransition);
        }
        self.rating = Some(rating);
        self.comment = comment;
        Ok(())
    }

    /// Ends a job that has not finished.
    ///
    /// `cancelled` existed in the domain and in the database CHECK from the
    /// start, but nothing ever wrote it, so there was no way out of a job:
    /// a client whose auction drew no bids kept it forever, and an
    /// abandoned job sat in `active` for good (GAP-19).
    ///
    /// Terminal states are refused — there is nothing to cancel once the
    /// work is done, and cancelling twice is not a second event. Calling
    /// this on an already-cancelled job is an error rather than a no-op
    /// because the caller had to read the job to get here, so a repeat
    /// means a stale view or a double submit, and silently accepting it
    /// would erase the original reason and timestamp.
    pub fn cancel(&mut self, by: Uuid, reason: Option<String>) -> Result<(), JobError> {
        match self.status {
            JobStatus::Completed => return Err(JobError::InvalidStatusTransition),
            JobStatus::Cancelled => return Err(JobError::InvalidStatusTransition),
            JobStatus::Pending | JobStatus::Active => {}
        }

        self.status = JobStatus::Cancelled;
        self.cancelled_at = Some(Utc::now());
        self.cancelled_by = Some(by);
        self.cancellation_reason = reason
            .map(|reason| reason.trim().to_string())
            .filter(|reason| !reason.is_empty());

        Ok(())
    }

    /// True once the job has reached a state nothing can move it out of.
    pub fn is_terminal(&self) -> bool {
        matches!(self.status, JobStatus::Completed | JobStatus::Cancelled)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn job(kind: &str) -> JobRequest {
        JobRequest::new(
            Uuid::new_v4(),
            None,
            None,
            kind.to_string(),
            kind.to_string(),
            None,
            None,
            true,
        )
    }

    #[test]
    fn every_kind_is_free_for_the_client() {
        let direct = job("direct");
        let project = job("project");
        let bidding = job("bidding");

        // Free for the client, but waits for the technician to accept.
        assert_eq!((direct.fee_amount, direct.fee_paid, direct.status), (0, true, JobStatus::Pending));
        assert_eq!((project.fee_amount, project.fee_paid, project.status), (0, true, JobStatus::Active));
        // Free for the client, but open until an offer is picked.
        assert_eq!((bidding.fee_amount, bidding.fee_paid, bidding.status), (0, true, JobStatus::Pending));
    }

    #[test]
    fn bidding_starts_when_the_client_picks_a_winner() {
        let mut bidding = job("bidding");
        // Paying is a no-op now: nothing is owed, and it must not start
        // an auction that has no technician yet.
        bidding.pay_fee().unwrap();
        assert_eq!(bidding.status, JobStatus::Pending);

        bidding.assign_winner(7, 150).unwrap();
        assert_eq!(bidding.technician_profile_id, Some(7));
        assert_eq!(bidding.agreed_price, Some(150));
        assert_eq!((bidding.status, bidding.timeline_step), (JobStatus::Active, 0));
    }

    #[test]
    fn an_auction_opened_under_the_old_client_fee_still_starts_on_a_win() {
        let mut legacy = job("bidding");
        legacy.fee_amount = 4;
        legacy.fee_paid = false;

        legacy.assign_winner(7, 150).unwrap();
        assert!(legacy.fee_paid);
        assert_eq!(legacy.status, JobStatus::Active);
    }

    #[test]
    fn a_winner_is_picked_once_and_only_on_open_auctions() {
        let mut bidding = job("bidding");
        bidding.assign_winner(7, 150).unwrap();
        assert!(bidding.assign_winner(8, 120).is_err(), "reassigning a started job");

        let mut direct = job("direct");
        assert!(direct.assign_winner(7, 150).is_err(), "a direct hire is not an auction");
    }

    #[test]
    fn free_job_payment_retry_is_harmless() {
        let mut project = job("project");
        project.pay_fee().unwrap();
        assert_eq!(project.status, JobStatus::Active);
        assert_eq!(project.timeline_step, 0);
    }

    fn direct_for(profile: i32) -> JobRequest {
        JobRequest::new(Uuid::new_v4(), Some(profile), None, "direct".into(), "direct".into(), None, None, true)
    }

    #[test]
    fn a_direct_hire_starts_only_when_the_named_technician_accepts() {
        let mut direct = direct_for(7);
        assert_eq!(direct.status, JobStatus::Pending);
        assert!(matches!(direct.accept_direct(8), Err(JobError::Unauthorized)), "another technician");
        direct.accept_direct(7).unwrap();
        assert_eq!((direct.status.clone(), direct.timeline_step), (JobStatus::Active, 0));
        assert!(direct.accept_direct(7).is_err(), "accepting twice");
    }

    #[test]
    fn the_named_technician_can_decline_an_unaccepted_direct_hire() {
        let mut direct = direct_for(7);
        assert!(matches!(direct.decline_direct(8, Uuid::new_v4()), Err(JobError::Unauthorized)));
        direct.decline_direct(7, Uuid::new_v4()).unwrap();
        assert_eq!(direct.status, JobStatus::Cancelled);

        let mut accepted = direct_for(7);
        accepted.accept_direct(7).unwrap();
        assert!(accepted.decline_direct(7, Uuid::new_v4()).is_err(), "too late to decline");
    }

    #[test]
    fn a_credit_is_refunded_only_for_a_started_job_before_any_work() {
        let mut direct = direct_for(7);
        assert!(!direct.refunds_credit_on_cancel(), "never accepted, nothing was paid");
        direct.accept_direct(7).unwrap();
        assert!(direct.refunds_credit_on_cancel());
        direct.advance_timeline().unwrap();
        assert!(!direct.refunds_credit_on_cancel(), "work already started");
    }

    #[test]
    fn rating_rejects_boundaries_and_duplicate_submissions() {
        let mut completed = job("direct");
        completed.status = JobStatus::Completed;
        completed.timeline_step = 3;

        assert!(completed.rate(0, None).is_err());
        assert!(completed.rate(6, None).is_err());
        completed.rate(5, Some("Excelente".to_string())).unwrap();
        assert!(completed.rate(1, None).is_err());
    }

    #[test]
    fn timeline_cannot_advance_after_completion() {
        let mut direct = job("project");
        for _ in 0..3 {
            direct.advance_timeline().unwrap();
        }
        assert_eq!(direct.status, JobStatus::Completed);
        assert!(direct.advance_timeline().is_err());
    }
}
