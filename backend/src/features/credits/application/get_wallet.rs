use std::sync::Arc;

use uuid::Uuid;

use crate::features::credits::domain::{CreditError, CreditRepository, Wallet};
use crate::features::technician::domain::TechnicianRepository;

pub struct GetWalletUseCase {
    credit_repo: Arc<dyn CreditRepository>,
    technician_repo: Arc<dyn TechnicianRepository>,
}

impl GetWalletUseCase {
    pub fn new(credit_repo: Arc<dyn CreditRepository>, technician_repo: Arc<dyn TechnicianRepository>) -> Self {
        Self { credit_repo, technician_repo }
    }

    pub async fn execute(&self, technician_user_id: Uuid) -> Result<Wallet, CreditError> {
        let profile = self
            .technician_repo
            .find_profile_by_user_id(technician_user_id)
            .await
            .map_err(|e| CreditError::Repository(e.to_string()))?
            .ok_or(CreditError::NotATechnician)?;
        self.credit_repo.wallet(profile.id).await
    }
}
