use std::sync::Arc;

use crate::features::technician::domain::{TechTeam, TechnicianError, TechnicianProfile, TechnicianRepository};

pub struct ListProvidersOutput {
    pub technicians: Vec<TechnicianProfile>,
    pub teams: Vec<TechTeam>,
}

pub struct GetProvidersUseCase {
    technician_repo: Arc<dyn TechnicianRepository>,
}

impl GetProvidersUseCase {
    pub fn new(technician_repo: Arc<dyn TechnicianRepository>) -> Self {
        Self { technician_repo }
    }

    pub async fn execute(&self, category: Option<String>) -> Result<ListProvidersOutput, TechnicianError> {
        let technicians = self.technician_repo.list_profiles(category.as_deref()).await?;
        let teams = self.technician_repo.list_teams().await?;
        Ok(ListProvidersOutput { technicians, teams })
    }
}
