use async_trait::async_trait;
use uuid::Uuid;

use crate::features::job::application::ports::{PaymentCapture, PaymentError, PaymentGateway, TokenCharge};

/// Simulates a successful capture with a short delay so the client can
/// show a realistic "Procesando…" state. Must never be wired in production
/// (`main` panics if `PAYMENTS_MODE=fake` with `APP_ENV=production`).
pub struct FakePaymentGateway;

#[async_trait]
impl PaymentGateway for FakePaymentGateway {
    async fn capture_fee(
        &self,
        amount_soles: i32,
        payment_method: &str,
        idempotency_key: Uuid,
    ) -> Result<PaymentCapture, PaymentError> {
        // Enough to feel real in the UI without slowing tests noticeably.
        tokio::time::sleep(std::time::Duration::from_millis(350)).await;

        tracing::warn!(
            amount_soles,
            payment_method,
            %idempotency_key,
            "PAYMENTS_MODE=fake — no money was collected"
        );

        Ok(PaymentCapture {
            gateway: "fake".to_string(),
            gateway_reference: format!("fake-{idempotency_key}"),
            simulated: true,
        })
    }

    async fn charge_token(&self, charge: &TokenCharge) -> Result<PaymentCapture, PaymentError> {
        tokio::time::sleep(std::time::Duration::from_millis(350)).await;

        // Lets the app and the tests exercise the decline path.
        if charge.source_id == FAKE_DECLINED_TOKEN {
            return Err(PaymentError::Rejected {
                user_message: "Tu tarjeta fue rechazada (simulado). Prueba con otra tarjeta.".to_string(),
            });
        }

        tracing::warn!(
            amount_cents = charge.amount_cents,
            idempotency_key = %charge.idempotency_key,
            "PAYMENTS_MODE=fake — no money was collected"
        );

        Ok(PaymentCapture {
            gateway: "fake".to_string(),
            gateway_reference: format!("fake-{}", charge.idempotency_key),
            simulated: true,
        })
    }
}

/// A token the fake gateway always declines.
pub const FAKE_DECLINED_TOKEN: &str = "tkn_fake_declined";

/// Answers 503 until a real adapter exists.
pub struct UnconfiguredPaymentGateway;

#[async_trait]
impl PaymentGateway for UnconfiguredPaymentGateway {
    async fn capture_fee(
        &self,
        _amount_soles: i32,
        _payment_method: &str,
        _idempotency_key: Uuid,
    ) -> Result<PaymentCapture, PaymentError> {
        Err(PaymentError::Unavailable)
    }

    async fn charge_token(&self, _charge: &TokenCharge) -> Result<PaymentCapture, PaymentError> {
        Err(PaymentError::Unavailable)
    }
}
