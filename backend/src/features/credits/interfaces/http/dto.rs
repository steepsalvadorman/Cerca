use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::features::credits::domain::{CreditPack, Wallet};

#[derive(Serialize)]
pub struct PackResponse {
    pub id: &'static str,
    pub credits: i32,
    pub price_cents: i32,
}

impl From<&CreditPack> for PackResponse {
    fn from(pack: &CreditPack) -> Self {
        Self { id: pack.id, credits: pack.credits, price_cents: pack.price_cents }
    }
}

#[derive(Serialize)]
pub struct PaymentsConfigResponse {
    pub mode: String,
    pub culqi_public_key: Option<String>,
}

#[derive(Serialize)]
pub struct WalletResponse {
    pub balance: i64,
    pub reserved: i64,
    pub available: i64,
}

impl From<Wallet> for WalletResponse {
    fn from(wallet: Wallet) -> Self {
        Self { balance: wallet.balance, reserved: wallet.reserved, available: wallet.available() }
    }
}

#[derive(Serialize)]
pub struct CreditsOverviewResponse {
    pub wallet: WalletResponse,
    pub packs: Vec<PackResponse>,
    pub payments: PaymentsConfigResponse,
}

#[derive(Deserialize)]
pub struct PurchaseRequest {
    pub purchase_id: Uuid,
    pub pack_id: String,
    pub source_id: String,
}

impl PurchaseRequest {
    /// Culqi tokens are 25 characters (`tkn_test_…`, `ype_live_…`); the
    /// bound only rejects the absurd before it reaches the PSP.
    pub fn validated(self) -> Result<Self, String> {
        let source = self.source_id.trim();
        if source.is_empty() || source.len() > 64 {
            return Err("source_id: token de pago inválido".to_string());
        }
        Ok(Self { source_id: source.to_string(), ..self })
    }
}

#[derive(Serialize)]
pub struct PurchaseResponse {
    pub status: &'static str,
    pub credits_added: i32,
    pub simulated: bool,
    pub wallet: WalletResponse,
}
