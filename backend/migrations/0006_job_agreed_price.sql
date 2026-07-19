-- Once a client chooses a bidding offer, nothing recorded which offer (or
-- price) was actually accepted — only the winning technician_profile_id.
-- The frontend was showing a hardcoded placeholder price because there was
-- no real number to show. NULL for "direct" (paid/negotiated in cash
-- directly with the technician) and "project" (priced from the team's
-- labor/materials/mobility costs, not a single stored number).
ALTER TABLE job_requests ADD COLUMN IF NOT EXISTS agreed_price INT;
