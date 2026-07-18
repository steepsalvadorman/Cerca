use async_trait::async_trait;
use uuid::Uuid;

use super::errors::TechnicianError;
use super::technician_document::{DocStatus, TechnicianDocument};
use super::technician_profile::TechnicianProfile;
use super::tech_team::TechTeam;

#[async_trait]
pub trait TechnicianRepository: Send + Sync {
    async fn find_profile_by_user_id(&self, user_id: Uuid) -> Result<Option<TechnicianProfile>, TechnicianError>;
    // Not called by any use case yet — reserved for an upcoming "technician detail" endpoint.
    #[allow(dead_code)]
    async fn find_profile_by_id(&self, id: i32) -> Result<Option<TechnicianProfile>, TechnicianError>;
    async fn save_profile(&self, profile: &TechnicianProfile) -> Result<(), TechnicianError>;
    async fn list_profiles(&self, category: Option<&str>) -> Result<Vec<TechnicianProfile>, TechnicianError>;
    async fn list_teams(&self) -> Result<Vec<TechTeam>, TechnicianError>;
    // Not called by any use case yet — reserved for an upcoming "team detail" endpoint.
    #[allow(dead_code)]
    async fn find_team_by_id(&self, id: i32) -> Result<Option<TechTeam>, TechnicianError>;
    async fn find_documents(&self, technician_profile_id: i32) -> Result<Vec<TechnicianDocument>, TechnicianError>;
    async fn update_document_status(&self, technician_profile_id: i32, document_key: &str, status: DocStatus) -> Result<(), TechnicianError>;
}
