use std::sync::Arc;
use uuid::Uuid;

use crate::features::client::domain::{ClientAddress, ClientError, ClientRepository};

pub struct AddAddressInput {
    pub client_id: Uuid,
    pub label: String,
    pub detail: String,
}

pub struct AddAddressUseCase {
    client_repo: Arc<dyn ClientRepository>,
}

impl AddAddressUseCase {
    pub fn new(client_repo: Arc<dyn ClientRepository>) -> Self {
        Self { client_repo }
    }

    pub async fn execute(&self, input: AddAddressInput) -> Result<ClientAddress, ClientError> {
        let address = ClientAddress::new(input.client_id, input.label, input.detail);
        self.client_repo.add_address(&address).await?;
        Ok(address)
    }
}
