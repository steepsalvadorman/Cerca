use async_trait::async_trait;
use uuid::Uuid;

use super::client_address::ClientAddress;
use super::client_payment_method::ClientPaymentMethod;
use super::errors::ClientError;

#[async_trait]
pub trait ClientRepository: Send + Sync {
    async fn find_addresses(&self, client_id: Uuid) -> Result<Vec<ClientAddress>, ClientError>;
    async fn add_address(&self, address: &ClientAddress) -> Result<(), ClientError>;
    async fn find_payment_methods(&self, client_id: Uuid) -> Result<Vec<ClientPaymentMethod>, ClientError>;
    async fn add_payment_method(&self, method: &ClientPaymentMethod) -> Result<(), ClientError>;
    async fn save_profile_saved(&self, client_id: Uuid, saved: bool) -> Result<(), ClientError>;
    async fn is_profile_saved(&self, client_id: Uuid) -> Result<bool, ClientError>;
}
