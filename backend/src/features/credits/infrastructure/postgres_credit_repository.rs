use async_trait::async_trait;
use chrono::{DateTime, Utc};
use sqlx::PgPool;
use uuid::Uuid;

use crate::features::credits::domain::{
    CreditError, CreditPurchase, CreditRepository, PurchaseStatus, Wallet, WELCOME_CREDITS,
};

/// Grants the welcome credits (once — a partial unique index makes the
/// second insert a no-op) and reads the wallet.
///
/// Shared with the job repository, which needs the same answer to decide
/// whether a technician may bid.
pub async fn read_wallet(pool: &PgPool, technician_profile_id: i32) -> Result<Wallet, sqlx::Error> {
    sqlx::query(
        "INSERT INTO credit_ledger (technician_profile_id, delta, reason) VALUES ($1, $2, 'welcome') \
         ON CONFLICT (technician_profile_id) WHERE reason = 'welcome' DO NOTHING",
    )
    .bind(technician_profile_id)
    .bind(WELCOME_CREDITS)
    .execute(pool)
    .await?;

    let (balance,): (i64,) = sqlx::query_as(
        "SELECT COALESCE(SUM(delta), 0)::BIGINT FROM credit_ledger WHERE technician_profile_id = $1",
    )
    .bind(technician_profile_id)
    .fetch_one(pool)
    .await?;

    // Offers on auctions that are still open: each one may still be
    // picked and cost a credit.
    let (reserved,): (i64,) = sqlx::query_as(
        "SELECT COUNT(*)::BIGINT FROM job_offers jo \
         JOIN job_requests jr ON jr.id = jo.job_request_id \
         WHERE jo.technician_profile_id = $1 \
           AND jr.status = 'pending' AND jr.technician_profile_id IS NULL",
    )
    .bind(technician_profile_id)
    .fetch_one(pool)
    .await?;

    Ok(Wallet { balance, reserved })
}

pub struct PostgresCreditRepository {
    pool: PgPool,
}

impl PostgresCreditRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }
}

fn repo_err(e: sqlx::Error) -> CreditError {
    CreditError::Repository(e.to_string())
}

#[derive(sqlx::FromRow)]
struct PurchaseRow {
    id: Uuid,
    technician_profile_id: i32,
    pack_id: String,
    credits: i32,
    amount_cents: i32,
    status: String,
    gateway: Option<String>,
    gateway_reference: Option<String>,
    failure_message: Option<String>,
    simulated: bool,
    created_at: DateTime<Utc>,
}

impl From<PurchaseRow> for CreditPurchase {
    fn from(row: PurchaseRow) -> Self {
        CreditPurchase {
            id: row.id,
            technician_profile_id: row.technician_profile_id,
            pack_id: row.pack_id,
            credits: row.credits,
            amount_cents: row.amount_cents,
            status: PurchaseStatus::parse(&row.status),
            gateway: row.gateway,
            gateway_reference: row.gateway_reference,
            failure_message: row.failure_message,
            simulated: row.simulated,
            created_at: row.created_at,
        }
    }
}

#[async_trait]
impl CreditRepository for PostgresCreditRepository {
    async fn wallet(&self, technician_profile_id: i32) -> Result<Wallet, CreditError> {
        read_wallet(&self.pool, technician_profile_id).await.map_err(repo_err)
    }

    async fn find_purchase(&self, id: Uuid) -> Result<Option<CreditPurchase>, CreditError> {
        let row = sqlx::query_as::<_, PurchaseRow>(
            "SELECT id, technician_profile_id, pack_id, credits, amount_cents, status, gateway, \
             gateway_reference, failure_message, simulated, created_at \
             FROM credit_purchases WHERE id = $1",
        )
        .bind(id)
        .fetch_optional(&self.pool)
        .await
        .map_err(repo_err)?;
        Ok(row.map(Into::into))
    }

    async fn create_purchase(&self, purchase: &CreditPurchase) -> Result<(), CreditError> {
        let result = sqlx::query(
            "INSERT INTO credit_purchases (id, technician_profile_id, pack_id, credits, amount_cents, status, created_at) \
             VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT (id) DO NOTHING",
        )
        .bind(purchase.id)
        .bind(purchase.technician_profile_id)
        .bind(&purchase.pack_id)
        .bind(purchase.credits)
        .bind(purchase.amount_cents)
        .bind(purchase.status.as_str())
        .bind(purchase.created_at)
        .execute(&self.pool)
        .await
        .map_err(repo_err)?;

        // Two concurrent requests with the same key: only one may charge.
        if result.rows_affected() == 0 {
            return Err(CreditError::PurchaseConflict);
        }
        Ok(())
    }

    async fn complete_purchase(
        &self,
        id: Uuid,
        gateway: &str,
        gateway_reference: &str,
        simulated: bool,
    ) -> Result<(), CreditError> {
        let mut tx = self.pool.begin().await.map_err(repo_err)?;

        let row: Option<(i32, i32)> = sqlx::query_as(
            "UPDATE credit_purchases SET status = 'paid', gateway = $2, gateway_reference = $3, \
             simulated = $4, paid_at = now() WHERE id = $1 RETURNING technician_profile_id, credits",
        )
        .bind(id)
        .bind(gateway)
        .bind(gateway_reference)
        .bind(simulated)
        .fetch_optional(&mut *tx)
        .await
        .map_err(repo_err)?;

        let Some((technician_profile_id, credits)) = row else {
            return Err(CreditError::Repository(format!("purchase {id} vanished")));
        };

        sqlx::query(
            "INSERT INTO credit_ledger (technician_profile_id, delta, reason, purchase_id) \
             VALUES ($1, $2, 'purchase', $3) \
             ON CONFLICT (purchase_id) WHERE reason = 'purchase' DO NOTHING",
        )
        .bind(technician_profile_id)
        .bind(credits)
        .bind(id)
        .execute(&mut *tx)
        .await
        .map_err(repo_err)?;

        tx.commit().await.map_err(repo_err)
    }

    async fn fail_purchase(&self, id: Uuid, gateway: &str, message: &str) -> Result<(), CreditError> {
        sqlx::query(
            "UPDATE credit_purchases SET status = 'failed', gateway = $2, failure_message = $3 \
             WHERE id = $1 AND status = 'pending'",
        )
        .bind(id)
        .bind(gateway)
        .bind(message)
        .execute(&self.pool)
        .await
        .map_err(repo_err)?;
        Ok(())
    }
}
