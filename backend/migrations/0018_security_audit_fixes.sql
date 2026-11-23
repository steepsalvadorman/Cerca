-- Fixes from security audit run-1.

-- One identity per provider per user. Without this, a second Google
-- subject with the same email could be bound to an account that already
-- had one (auth:google-link:duplicate-subject-email-collision). Keep the
-- oldest binding if duplicates already exist.
DELETE FROM auth_identities a
USING auth_identities b
WHERE a.user_id = b.user_id
  AND a.provider = b.provider
  AND a.created_at > b.created_at;

CREATE UNIQUE INDEX IF NOT EXISTS auth_identities_one_per_provider
    ON auth_identities (user_id, provider);

-- A client cancelling a job before work starts gives the technician their
-- credit back; at most once per job, however often the request is retried
-- (backend/src/features/job/application/cancel_job.rs).
CREATE UNIQUE INDEX IF NOT EXISTS credit_ledger_one_refund_per_job
    ON credit_ledger (job_request_id) WHERE reason = 'refund';
