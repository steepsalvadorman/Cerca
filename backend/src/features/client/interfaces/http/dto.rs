use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::features::client::domain::{ClientAddress, ClientPaymentMethod};

#[derive(Serialize)]
pub struct AddressResponse {
    pub id: Uuid,
    pub label: String,
    pub detail: String,
}

impl From<ClientAddress> for AddressResponse {
    fn from(a: ClientAddress) -> Self {
        Self {
            id: a.id,
            label: a.label,
            detail: a.detail,
        }
    }
}

#[derive(Deserialize)]
pub struct AddAddressRequest {
    pub label: String,
    pub detail: String,
}

#[derive(Serialize)]
pub struct PaymentMethodResponse {
    pub id: Uuid,
    pub label: String,
    pub detail: String,
}

impl From<ClientPaymentMethod> for PaymentMethodResponse {
    fn from(m: ClientPaymentMethod) -> Self {
        Self {
            id: m.id,
            label: m.label,
            detail: m.detail,
        }
    }
}

#[derive(Deserialize)]
pub struct AddPaymentMethodRequest {
    pub label: String,
    pub detail: String,
}

#[derive(Deserialize)]
pub struct SaveClientProfileRequest {
    pub saved: bool,
}

#[derive(Serialize)]
pub struct ClientProfileStatusResponse {
    pub profile_saved: bool,
}
