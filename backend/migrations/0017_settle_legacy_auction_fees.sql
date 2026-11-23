-- Auctions opened before 0016 carry the old client fee (S/ 4, unpaid).
-- The client no longer pays, so settle it: open auctions stop waiting on
-- a payment that will never be asked for, and ones whose winner was
-- already picked (but stayed pending for the fee) start now.

UPDATE job_requests
SET fee_amount = 0, fee_paid = TRUE, version = version + 1
WHERE job_kind = 'bidding' AND status = 'pending' AND fee_paid = FALSE;

UPDATE job_requests
SET status = 'active', timeline_step = 0, version = version + 1
WHERE job_kind = 'bidding' AND status = 'pending' AND technician_profile_id IS NOT NULL;
