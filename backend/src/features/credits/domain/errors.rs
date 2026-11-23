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
    /// A previous attempt with this purchase id has an unresolved outcome
    /// (the PSP may have charged); it is never charged a second time.
    #[error("tu pago anterior todavía se está confirmando; revisa tus créditos en unos minutos")]
    PaymentPending,
    #[error("database error: {0}")]
    Repository(String),
}
