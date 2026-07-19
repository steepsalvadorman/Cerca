-- Makes the app-fee amount and the "movilidad incluida" choice server-owned
-- data instead of client-side-only state: previously neither was persisted,
-- so the fee shown in the app could drift from what's actually charged and
-- a client's mobility choice for a project quote was lost once the job was
-- created.
ALTER TABLE job_requests ADD COLUMN IF NOT EXISTS mobility_included BOOLEAN NOT NULL DEFAULT true;
ALTER TABLE job_requests ADD COLUMN IF NOT EXISTS fee_amount INT NOT NULL DEFAULT 0;
