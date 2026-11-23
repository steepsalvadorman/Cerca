-- Technician credits: the technician pays Cerca, not the client.
--
-- A technician buys a pack of credits (one card/Yape charge through the
-- PSP) and spends one credit each time a client picks their offer. The
-- client side of bidding becomes free. Charging S/ 4 per auction to the
-- client lost a quarter or more of each fee to the PSP's fixed cost and
-- needed one electronic receipt per S/ 4; a pack pays that cost once.

-- What a technician paid for. One row per purchase attempt; `id` doubles
-- as the idempotency key the app generates, so a retried request finds
-- the original attempt instead of charging twice.
CREATE TABLE IF NOT EXISTS credit_purchases (
    id UUID PRIMARY KEY,
    technician_profile_id INT NOT NULL REFERENCES technician_profiles(id) ON DELETE CASCADE,
    pack_id TEXT NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    amount_cents INT NOT NULL CHECK (amount_cents > 0),
    status TEXT NOT NULL CHECK (status IN ('pending', 'paid', 'failed')),
    gateway TEXT,
    gateway_reference TEXT,
    failure_message TEXT,
    simulated BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    paid_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS credit_purchases_technician_idx
    ON credit_purchases (technician_profile_id, created_at DESC);

-- Append-only ledger. The balance is SUM(delta); nothing is ever updated
-- or deleted, so every credit can be traced to why it exists.
CREATE TABLE IF NOT EXISTS credit_ledger (
    id BIGSERIAL PRIMARY KEY,
    technician_profile_id INT NOT NULL REFERENCES technician_profiles(id) ON DELETE CASCADE,
    delta INT NOT NULL CHECK (delta <> 0),
    reason TEXT NOT NULL CHECK (reason IN ('welcome', 'purchase', 'job_won', 'refund', 'adjustment')),
    job_request_id UUID REFERENCES job_requests(id) ON DELETE SET NULL,
    purchase_id UUID REFERENCES credit_purchases(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS credit_ledger_technician_idx
    ON credit_ledger (technician_profile_id);

-- Each of these events can credit or debit at most once, however many
-- times the request that causes it is retried.
CREATE UNIQUE INDEX IF NOT EXISTS credit_ledger_one_welcome
    ON credit_ledger (technician_profile_id) WHERE reason = 'welcome';
CREATE UNIQUE INDEX IF NOT EXISTS credit_ledger_one_win_per_job
    ON credit_ledger (job_request_id) WHERE reason = 'job_won';
CREATE UNIQUE INDEX IF NOT EXISTS credit_ledger_one_entry_per_purchase
    ON credit_ledger (purchase_id) WHERE reason = 'purchase';
