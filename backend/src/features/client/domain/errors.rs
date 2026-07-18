use thiserror::Error;

// Not yet constructed by any use case — reserved for lookups that
// don't check existence yet (get/delete address, get payment method).
#[allow(dead_code)]
#[derive(Debug, Error, Clone)]
pub enum ClientError {
    #[error("client profile not found")]
    ClientNotFound,

    #[error("address not found")]
    AddressNotFound,

    #[error("payment method not found")]
    PaymentMethodNotFound,

    #[error("database error: {0}")]
    Repository(String),
}
