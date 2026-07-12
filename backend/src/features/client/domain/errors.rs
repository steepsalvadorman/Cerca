use thiserror::Error;

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
