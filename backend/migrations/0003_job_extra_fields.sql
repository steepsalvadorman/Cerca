-- Adds fields needed to make the job flow usable end-to-end from the client app:
-- a human-readable title/address captured when the job is created, and a
-- free-text comment captured alongside the star rating.
ALTER TABLE job_requests ADD COLUMN IF NOT EXISTS title TEXT;
ALTER TABLE job_requests ADD COLUMN IF NOT EXISTS address TEXT;
ALTER TABLE job_requests ADD COLUMN IF NOT EXISTS comment TEXT;
