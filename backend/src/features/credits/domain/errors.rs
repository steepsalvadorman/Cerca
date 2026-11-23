use thiserror::Error;

#[derive(Debug, Error, Clone)]
pub enum CreditError {
    #[error("solo los técnicos registrados tienen créditos")]
    NotATechnician,
    #[error("ese paquete de créditos no existe")]
    UnknownPack,
    /// The idempotency key was already used for a different technician or
    /// pack: a client bug or a replay, never a legitimate retry.
    #[error("esta compra ya existe con otros datos")]
    PurchaseConflict,
    /// The PSP refused the charge. Carries the PSP's message for the user
    /// ("fondos insuficientes", "tarjeta vencida"…) when it gave one.
    #[error("{0}")]
    PaymentDeclined(String),
    #[error("el proveedor de pagos no está disponible")]
    PaymentUnavailable,
    #[error("database error: {0}")]
    Repository(String),
}
