pub mod add_address;
pub mod add_payment_method;
pub mod save_profile;

use std::sync::Arc;
use uuid::Uuid;

use crate::features::client::domain::{ClientAddress, ClientError, ClientPaymentMethod, ClientRepository};

pub use add_address::{AddAddressInput, AddAddressUseCase};
pub use add_payment_method::{AddPaymentMethodInput, AddPaymentMethodUseCase};
pub use save_profile::SaveClientProfileUseCase;

pub struct GetClientAddressesUseCase {
    client_repo: Arc<dyn ClientRepository>,
}

impl GetClientAddressesUseCase {
    pub fn new(client_repo: Arc<dyn ClientRepository>) -> Self {
        Self { client_repo }
    }

    pub async fn execute(&self, client_id: Uuid) -> Result<Vec<ClientAddress>, ClientError> {
        self.client_repo.find_addresses(client_id).await
    }
}

pub struct GetClientPaymentMethodsUseCase {
    client_repo: Arc<dyn ClientRepository>,
}

impl GetClientPaymentMethodsUseCase {
    pub fn new(client_repo: Arc<dyn ClientRepository>) -> Self {
        Self { client_repo }
    }

    pub async fn execute(&self, client_id: Uuid) -> Result<Vec<ClientPaymentMethod>, ClientError> {
        self.client_repo.find_payment_methods(client_id).await
    }
}

pub struct GetClientProfileStatusUseCase {
    client_repo: Arc<dyn ClientRepository>,
}

impl GetClientProfileStatusUseCase {
    pub fn new(client_repo: Arc<dyn ClientRepository>) -> Self {
        Self { client_repo }
    }

    pub async fn execute(&self, client_id: Uuid) -> Result<bool, ClientError> {
        self.client_repo.is_profile_saved(client_id).await
    }
}
