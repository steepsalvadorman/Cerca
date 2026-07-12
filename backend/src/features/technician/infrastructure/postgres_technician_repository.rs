use async_trait::async_trait;
use sqlx::PgPool;
use uuid::Uuid;

use crate::features::technician::domain::{
    DocStatus, TechTeam, TechnicianDocument, TechnicianError, TechnicianProfile, TechnicianRepository,
};

#[derive(sqlx::FromRow)]
struct TechnicianProfileRow {
    id: i32,
    user_id: Uuid,
    name: String,
    oficio: String,
    rating: f64,
    reviews: i32,
    distance: String,
    price_label: String,
    pin_top: f64,
    pin_left: f64,
    coverage_km: i32,
    available_days: Vec<String>,
    categories: Vec<String>,
    is_verified: bool,
}

impl From<TechnicianProfileRow> for TechnicianProfile {
    fn from(row: TechnicianProfileRow) -> Self {
        Self {
            id: row.id,
            user_id: row.user_id,
            mono: TechnicianProfile::get_mono(&row.name),
            name: row.name,
            oficio: row.oficio,
            rating: row.rating,
            reviews: row.reviews,
            distance: row.distance,
            price_label: row.price_label,
            pin_top: row.pin_top,
            pin_left: row.pin_left,
            coverage_km: row.coverage_km,
            available_days: row.available_days,
            categories: row.categories,
            is_verified: row.is_verified,
        }
    }
}

#[derive(sqlx::FromRow)]
struct TechTeamRow {
    id: i32,
    name: String,
    mono: String,
    oficio: String,
    rating: f64,
    reviews: i32,
    distance: String,
    price_label: String,
    pin_top: f64,
    pin_left: f64,
    crew: i32,
    projects: i32,
    labor_cost: i32,
    materials_cost: i32,
    mobility_cost: i32,
}

impl From<TechTeamRow> for TechTeam {
    fn from(row: TechTeamRow) -> Self {
        Self {
            id: row.id,
            name: row.name,
            mono: row.mono,
            oficio: row.oficio,
            rating: row.rating,
            reviews: row.reviews,
            distance: row.distance,
            price_label: row.price_label,
            pin_top: row.pin_top,
            pin_left: row.pin_left,
            crew: row.crew,
            projects: row.projects,
            labor_cost: row.labor_cost,
            materials_cost: row.materials_cost,
            mobility_cost: row.mobility_cost,
        }
    }
}

#[derive(sqlx::FromRow)]
struct TechnicianDocumentRow {
    id: Uuid,
    technician_profile_id: i32,
    document_key: String,
    status: String,
}

impl TryFrom<TechnicianDocumentRow> for TechnicianDocument {
    type Error = String;

    fn try_from(row: TechnicianDocumentRow) -> Result<Self, Self::Error> {
        Ok(Self {
            id: row.id,
            technician_profile_id: row.technician_profile_id,
            document_key: row.document_key,
            status: DocStatus::parse(&row.status)?,
        })
    }
}

pub struct PostgresTechnicianRepository {
    pool: PgPool,
}

impl PostgresTechnicianRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }
}

#[async_trait]
impl TechnicianRepository for PostgresTechnicianRepository {
    async fn find_profile_by_user_id(&self, user_id: Uuid) -> Result<Option<TechnicianProfile>, TechnicianError> {
        let row = sqlx::query_as::<_, TechnicianProfileRow>(
            "SELECT tp.id, tp.user_id, u.name, tp.oficio, tp.rating, tp.reviews, tp.distance, tp.price_label, \
             tp.pin_top, tp.pin_left, tp.coverage_km, tp.available_days, tp.categories, tp.is_verified \
             FROM technician_profiles tp \
             JOIN users u ON tp.user_id = u.id \
             WHERE tp.user_id = $1",
        )
        .bind(user_id)
        .fetch_optional(&self.pool)
        .await
        .map_err(|e| TechnicianError::Repository(e.to_string()))?;

        Ok(row.map(TechnicianProfile::from))
    }

    async fn find_profile_by_id(&self, id: i32) -> Result<Option<TechnicianProfile>, TechnicianError> {
        let row = sqlx::query_as::<_, TechnicianProfileRow>(
            "SELECT tp.id, tp.user_id, u.name, tp.oficio, tp.rating, tp.reviews, tp.distance, tp.price_label, \
             tp.pin_top, tp.pin_left, tp.coverage_km, tp.available_days, tp.categories, tp.is_verified \
             FROM technician_profiles tp \
             JOIN users u ON tp.user_id = u.id \
             WHERE tp.id = $1",
        )
        .bind(id)
        .fetch_optional(&self.pool)
        .await
        .map_err(|e| TechnicianError::Repository(e.to_string()))?;

        Ok(row.map(TechnicianProfile::from))
    }

    async fn save_profile(&self, profile: &TechnicianProfile) -> Result<(), TechnicianError> {
        sqlx::query(
            "INSERT INTO technician_profiles (user_id, oficio, rating, reviews, distance, price_label, pin_top, pin_left, coverage_km, available_days, categories, is_verified) \
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) \
             ON CONFLICT (user_id) DO UPDATE SET \
                oficio = EXCLUDED.oficio, \
                coverage_km = EXCLUDED.coverage_km, \
                available_days = EXCLUDED.available_days, \
                categories = EXCLUDED.categories, \
                is_verified = EXCLUDED.is_verified"
        )
        .bind(profile.user_id)
        .bind(&profile.oficio)
        .bind(profile.rating)
        .bind(profile.reviews)
        .bind(&profile.distance)
        .bind(&profile.price_label)
        .bind(profile.pin_top)
        .bind(profile.pin_left)
        .bind(profile.coverage_km)
        .bind(&profile.available_days)
        .bind(&profile.categories)
        .bind(profile.is_verified)
        .execute(&self.pool)
        .await
        .map_err(|e| TechnicianError::Repository(e.to_string()))?;

        Ok(())
    }

    async fn list_profiles(&self, category: Option<&str>) -> Result<Vec<TechnicianProfile>, TechnicianError> {
        let rows = sqlx::query_as::<_, TechnicianProfileRow>(
            "SELECT tp.id, tp.user_id, u.name, tp.oficio, tp.rating, tp.reviews, tp.distance, tp.price_label, \
             tp.pin_top, tp.pin_left, tp.coverage_km, tp.available_days, tp.categories, tp.is_verified \
             FROM technician_profiles tp \
             JOIN users u ON tp.user_id = u.id \
             WHERE $1 IS NULL OR $1 = ANY(tp.categories)",
        )
        .bind(category)
        .fetch_all(&self.pool)
        .await
        .map_err(|e| TechnicianError::Repository(e.to_string()))?;

        Ok(rows.into_iter().map(TechnicianProfile::from).collect())
    }

    async fn list_teams(&self) -> Result<Vec<TechTeam>, TechnicianError> {
        let rows = sqlx::query_as::<_, TechTeamRow>(
            "SELECT id, name, mono, oficio, rating, reviews, distance, price_label, pin_top, pin_left, crew, projects, labor_cost, materials_cost, mobility_cost \
             FROM tech_teams",
        )
        .fetch_all(&self.pool)
        .await
        .map_err(|e| TechnicianError::Repository(e.to_string()))?;

        Ok(rows.into_iter().map(TechTeam::from).collect())
    }

    async fn find_team_by_id(&self, id: i32) -> Result<Option<TechTeam>, TechnicianError> {
        let row = sqlx::query_as::<_, TechTeamRow>(
            "SELECT id, name, mono, oficio, rating, reviews, distance, price_label, pin_top, pin_left, crew, projects, labor_cost, materials_cost, mobility_cost \
             FROM tech_teams WHERE id = $1",
        )
        .bind(id)
        .fetch_optional(&self.pool)
        .await
        .map_err(|e| TechnicianError::Repository(e.to_string()))?;

        Ok(row.map(TechTeam::from))
    }

    async fn find_documents(&self, technician_profile_id: i32) -> Result<Vec<TechnicianDocument>, TechnicianError> {
        let rows = sqlx::query_as::<_, TechnicianDocumentRow>(
            "SELECT id, technician_profile_id, document_key, status FROM technician_documents \
             WHERE technician_profile_id = $1",
        )
        .bind(technician_profile_id)
        .fetch_all(&self.pool)
        .await
        .map_err(|e| TechnicianError::Repository(e.to_string()))?;

        let mut docs = Vec::new();
        for r in rows {
            let doc = TechnicianDocument::try_from(r)
                .map_err(|err| TechnicianError::Repository(err))?;
            docs.push(doc);
        }
        Ok(docs)
    }

    async fn update_document_status(&self, technician_profile_id: i32, document_key: &str, status: DocStatus) -> Result<(), TechnicianError> {
        sqlx::query(
            "INSERT INTO technician_documents (technician_profile_id, document_key, status) \
             VALUES ($1, $2, $3) \
             ON CONFLICT (technician_profile_id, document_key) DO UPDATE SET status = EXCLUDED.status",
        )
        .bind(technician_profile_id)
        .bind(document_key)
        .bind(status.as_str())
        .execute(&self.pool)
        .await
        .map_err(|e| TechnicianError::Repository(e.to_string()))?;

        Ok(())
    }
}
