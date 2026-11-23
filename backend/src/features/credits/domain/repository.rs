use async_trait::async_trait;
use uuid::Uuid;

use super::errors::CreditError;
use super::purchase::CreditPurchase;
use super::wallet::Wallet;

#[async_trait]
pub trait CreditRepository: Send + Sync {
    /// Reads the wallet, granting the one-time welcome credits first if
    /// this technician never had them.
    async fn wallet(&self, technician_profile_id: i32) -> Result<Wallet, CreditError>;
    async fn find_purchase(&self, id: Uuid) -> Result<Option<CreditPurchase>, CreditError>;
    async fn create_purchase(&self, purchase: &CreditPurchase) -> Result<(), CreditError>;
    /// Marks the purchase paid and adds its credits to the ledger, in one
    /// transaction. Safe to call twice: the second call adds nothing.
    async fn complete_purchase(
        &self,
        id: Uuid,
        gateway: &str,
        gateway_reference: &str,
        simulated: bool,
    ) -> Result<(), CreditError>;
    async fn fail_purchase(&self, id: Uuid, gateway: &str, message: &str) -> Result<(), CreditError>;
}
