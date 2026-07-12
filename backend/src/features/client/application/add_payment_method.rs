use std::sync::Arc;
use uuid::Uuid;

use crate::features::client::domain::{ClientError, ClientPaymentMethod, ClientRepository};

pub struct AddPaymentMethodInput {
    pub client_id: Uuid,
    pub label: String,
    pub detail: String,
}

pub struct AddPaymentMethodUseCase {
    client_repo: Arc<dyn ClientRepository>,
}

impl AddPaymentMethodUseCase {
    pub fn new(client_repo: Arc<dyn ClientRepository>) -> Self {
        Self { client_repo }
    }

    pub async fn execute(&self, input: AddPaymentMethodInput) -> Result<ClientPaymentMethod, ClientError> {
        let method = ClientPaymentMethod::new(input.client_id, input.label, input.detail);
        self.client_repo.add_payment_method(&method).await?;
        Ok(method)
    }
}
