use std::sync::Arc;
use uuid::Uuid;

use crate::features::client::domain::{ClientError, ClientRepository};

pub struct SaveClientProfileUseCase {
    client_repo: Arc<dyn ClientRepository>,
}

impl SaveClientProfileUseCase {
    pub fn new(client_repo: Arc<dyn ClientRepository>) -> Self {
        Self { client_repo }
    }

    pub async fn execute(&self, client_id: Uuid, saved: bool) -> Result<(), ClientError> {
        self.client_repo.save_profile_saved(client_id, saved).await
    }
}
