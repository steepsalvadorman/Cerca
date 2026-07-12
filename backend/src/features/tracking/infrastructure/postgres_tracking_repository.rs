use async_trait::async_trait;
use chrono::{DateTime, Utc};
use sqlx::PgPool;
use uuid::Uuid;

use crate::features::tracking::domain::{TechnicianLocation, TrackingError, TrackingRepository};

#[derive(sqlx::FromRow)]
struct TechnicianLocationRow {
    job_request_id: Uuid,
    latitude: f64,
    longitude: f64,
    updated_at: DateTime<Utc>,
}

impl From<TechnicianLocationRow> for TechnicianLocation {
    fn from(row: TechnicianLocationRow) -> Self {
        Self {
            job_request_id: row.job_request_id,
            latitude: row.latitude,
            longitude: row.longitude,
            updated_at: row.updated_at,
        }
    }
}

pub struct PostgresTrackingRepository {
    pool: PgPool,
}

impl PostgresTrackingRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }
}

#[async_trait]
impl TrackingRepository for PostgresTrackingRepository {
    async fn update_location(&self, location: &TechnicianLocation) -> Result<(), TrackingError> {
        sqlx::query(
            "INSERT INTO tracking_locations (job_request_id, latitude, longitude, updated_at) \
             VALUES ($1, $2, $3, $4) \
             ON CONFLICT (job_request_id) DO UPDATE SET \
                latitude = EXCLUDED.latitude, \
                longitude = EXCLUDED.longitude, \
                updated_at = EXCLUDED.updated_at",
        )
        .bind(location.job_request_id)
        .bind(location.latitude)
        .bind(location.longitude)
        .bind(location.updated_at)
        .execute(&self.pool)
        .await
        .map_err(|e| TrackingError::Repository(e.to_string()))?;

        Ok(())
    }

    async fn find_location_by_job_id(&self, job_request_id: Uuid) -> Result<Option<TechnicianLocation>, TrackingError> {
        let row = sqlx::query_as::<_, TechnicianLocationRow>(
            "SELECT job_request_id, latitude, longitude, updated_at \
             FROM tracking_locations WHERE job_request_id = $1",
        )
        .bind(job_request_id)
        .fetch_optional(&self.pool)
        .await
        .map_err(|e| TrackingError::Repository(e.to_string()))?;

        Ok(row.map(TechnicianLocation::from))
    }
}
