use async_trait::async_trait;
use sqlx::PgPool;
use uuid::Uuid;

use crate::features::client::domain::{
    ClientAddress, ClientError, ClientPaymentMethod, ClientRepository,
};

#[derive(sqlx::FromRow)]
struct ClientAddressRow {
    id: Uuid,
    client_id: Uuid,
    label: String,
    detail: String,
}

impl From<ClientAddressRow> for ClientAddress {
    fn from(row: ClientAddressRow) -> Self {
        Self {
            id: row.id,
            client_id: row.client_id,
            label: row.label,
            detail: row.detail,
        }
    }
}

#[derive(sqlx::FromRow)]
struct ClientPaymentMethodRow {
    id: Uuid,
    client_id: Uuid,
    label: String,
    detail: String,
}

impl From<ClientPaymentMethodRow> for ClientPaymentMethod {
    fn from(row: ClientPaymentMethodRow) -> Self {
        Self {
            id: row.id,
            client_id: row.client_id,
            label: row.label,
            detail: row.detail,
        }
    }
}

pub struct PostgresClientRepository {
    pool: PgPool,
}

impl PostgresClientRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }
}

#[async_trait]
impl ClientRepository for PostgresClientRepository {
    async fn find_addresses(&self, client_id: Uuid) -> Result<Vec<ClientAddress>, ClientError> {
        let rows = sqlx::query_as::<_, ClientAddressRow>(
            "SELECT id, client_id, label, detail FROM client_addresses WHERE client_id = $1",
        )
        .bind(client_id)
        .fetch_all(&self.pool)
        .await
        .map_err(|e| ClientError::Repository(e.to_string()))?;

        Ok(rows.into_iter().map(ClientAddress::from).collect())
    }

    async fn add_address(&self, address: &ClientAddress) -> Result<(), ClientError> {
        sqlx::query(
            "INSERT INTO client_addresses (id, client_id, label, detail) VALUES ($1, $2, $3, $4)",
        )
        .bind(address.id)
        .bind(address.client_id)
        .bind(&address.label)
        .bind(&address.detail)
        .execute(&self.pool)
        .await
        .map_err(|e| ClientError::Repository(e.to_string()))?;

        Ok(())
    }

    async fn find_payment_methods(&self, client_id: Uuid) -> Result<Vec<ClientPaymentMethod>, ClientError> {
        let rows = sqlx::query_as::<_, ClientPaymentMethodRow>(
            "SELECT id, client_id, label, detail FROM client_payment_methods WHERE client_id = $1",
        )
        .bind(client_id)
        .fetch_all(&self.pool)
        .await
        .map_err(|e| ClientError::Repository(e.to_string()))?;

        Ok(rows.into_iter().map(ClientPaymentMethod::from).collect())
    }

    async fn add_payment_method(&self, method: &ClientPaymentMethod) -> Result<(), ClientError> {
        sqlx::query(
            "INSERT INTO client_payment_methods (id, client_id, label, detail) VALUES ($1, $2, $3, $4)",
        )
        .bind(method.id)
        .bind(method.client_id)
        .bind(&method.label)
        .bind(&method.detail)
        .execute(&self.pool)
        .await
        .map_err(|e| ClientError::Repository(e.to_string()))?;

        Ok(())
    }

    async fn save_profile_saved(&self, client_id: Uuid, saved: bool) -> Result<(), ClientError> {
        sqlx::query(
            "INSERT INTO client_profiles (user_id, profile_saved) VALUES ($1, $2) \
             ON CONFLICT (user_id) DO UPDATE SET profile_saved = EXCLUDED.profile_saved",
        )
        .bind(client_id)
        .bind(saved)
        .execute(&self.pool)
        .await
        .map_err(|e| ClientError::Repository(e.to_string()))?;

        Ok(())
    }

    async fn is_profile_saved(&self, client_id: Uuid) -> Result<bool, ClientError> {
        let row = sqlx::query_scalar::<_, bool>(
            "SELECT profile_saved FROM client_profiles WHERE user_id = $1",
        )
        .bind(client_id)
        .fetch_optional(&self.pool)
        .await
        .map_err(|e| ClientError::Repository(e.to_string()))?;

        Ok(row.unwrap_or(false))
    }
}
