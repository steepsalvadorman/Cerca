//! Culqi adapter (API v2, https://apidocs.culqi.com).
//!
//! The app creates the token (card: `POST /v2/tokens`, Yape:
//! `POST /v2/tokens/yape`) with the *public* key, so card numbers never
//! reach this server. This adapter only turns that token into a charge
//! with the *secret* key.

use std::time::Duration;

use async_trait::async_trait;
use serde::Deserialize;
use serde_json::json;
use uuid::Uuid;

use crate::features::job::application::ports::{PaymentCapture, PaymentError, PaymentGateway, TokenCharge};

const DEFAULT_BASE_URL: &str = "https://api.culqi.com";

pub struct CulqiPaymentGateway {
    http: reqwest::Client,
    secret_key: String,
    base_url: String,
}

impl CulqiPaymentGateway {
    pub fn new(secret_key: String) -> Self {
        Self::with_base_url(secret_key, DEFAULT_BASE_URL.to_string())
    }

    pub fn with_base_url(secret_key: String, base_url: String) -> Self {
        let http = reqwest::Client::builder()
            .timeout(Duration::from_secs(20))
            .build()
            .expect("failed to build HTTP client");
        Self { http, secret_key, base_url }
    }
}

#[derive(Deserialize)]
struct ChargeResponse {
    id: Option<String>,
    object: Option<String>,
    action_code: Option<String>,
}

#[derive(Deserialize)]
struct ErrorResponse {
    #[serde(rename = "type")]
    kind: Option<String>,
    user_message: Option<String>,
    merchant_message: Option<String>,
}

/// Shown when the bank wants 3-D Secure, which the app does not drive yet.
const NEEDS_3DS_MESSAGE: &str =
    "Tu banco pide una verificación adicional que todavía no soportamos. Prueba con otra tarjeta o con Yape.";

/// Maps one Culqi HTTP answer to the port's outcome. Pure, so the mapping
/// is tested without a network.
pub(crate) fn interpret_charge_response(status: u16, body: &str) -> Result<PaymentCapture, PaymentError> {
    match status {
        200 | 201 => {
            let parsed: ChargeResponse = serde_json::from_str(body)
                .map_err(|e| PaymentError::Internal(format!("respuesta de Culqi ilegible: {e}")))?;
            if parsed.action_code.as_deref() == Some("REVIEW") {
                return Err(PaymentError::Rejected { user_message: NEEDS_3DS_MESSAGE.to_string() });
            }
            match (parsed.object.as_deref(), parsed.id) {
                (Some("charge"), Some(id)) => Ok(PaymentCapture {
                    gateway: "culqi".to_string(),
                    gateway_reference: id,
                    simulated: false,
                }),
                _ => Err(PaymentError::Internal("Culqi respondió sin un cargo".to_string())),
            }
        }
        400..=499 => {
            let parsed: ErrorResponse = serde_json::from_str(body).unwrap_or(ErrorResponse {
                kind: None,
                user_message: None,
                merchant_message: None,
            });
            match parsed.kind.as_deref() {
                // A decline the payer can act on: show Culqi's own words.
                Some("card_error") => Err(PaymentError::Rejected {
                    user_message: parsed
                        .user_message
                        .or(parsed.merchant_message)
                        .unwrap_or_else(|| "Tu pago fue rechazado. Prueba con otro medio de pago.".to_string()),
                }),
                Some("limit_api_error") => Err(PaymentError::Unavailable),
                // Bad key, bad parameters: our bug, not the payer's.
                _ => Err(PaymentError::Internal(
                    parsed.merchant_message.unwrap_or_else(|| format!("Culqi respondió {status}")),
                )),
            }
        }
        _ => Err(PaymentError::Unavailable),
    }
}

#[async_trait]
impl PaymentGateway for CulqiPaymentGateway {
    /// The per-job client fee no longer exists (migration 0016); nothing
    /// should call this with Culqi wired.
    async fn capture_fee(
        &self,
        _amount_soles: i32,
        _payment_method: &str,
        _idempotency_key: Uuid,
    ) -> Result<PaymentCapture, PaymentError> {
        Err(PaymentError::Unavailable)
    }

    async fn charge_token(&self, charge: &TokenCharge) -> Result<PaymentCapture, PaymentError> {
        let response = self
            .http
            .post(format!("{}/v2/charges", self.base_url))
            .bearer_auth(&self.secret_key)
            .json(&json!({
                "amount": charge.amount_cents,
                "currency_code": "PEN",
                "email": charge.email,
                "source_id": charge.source_id,
                "description": charge.description,
                // Lets a charge be traced back to its purchase when
                // reconciling against the Culqi panel.
                "metadata": { "purchase_id": charge.idempotency_key.to_string() },
            }))
            .send()
            .await
            .map_err(|e| {
                tracing::warn!(error = %e, "Culqi unreachable");
                PaymentError::Unavailable
            })?;

        let status = response.status().as_u16();
        let body = response.text().await.unwrap_or_default();
        let outcome = interpret_charge_response(status, &body);
        if let Err(PaymentError::Internal(reason)) = &outcome {
            tracing::error!(status, %reason, "Culqi charge failed on our side");
        }
        outcome
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn a_created_charge_is_captured() {
        let body = r#"{"object":"charge","id":"chr_test_HuVDSH10IoLKtYMa","outcome":{"type":"venta_exitosa"}}"#;
        let capture = interpret_charge_response(201, body).unwrap();
        assert_eq!(capture.gateway, "culqi");
        assert_eq!(capture.gateway_reference, "chr_test_HuVDSH10IoLKtYMa");
        assert!(!capture.simulated);
    }

    #[test]
    fn a_card_decline_carries_culqis_message_for_the_payer() {
        let body = r#"{"object":"error","type":"card_error","code":"DNGA0019","decline_code":"insufficient_funds",
            "merchant_message":"La tarjeta no tiene fondos suficientes.","user_message":"Su tarjeta no tiene fondos suficientes."}"#;
        match interpret_charge_response(402, body) {
            Err(PaymentError::Rejected { user_message }) => {
                assert_eq!(user_message, "Su tarjeta no tiene fondos suficientes.")
            }
            other => panic!("expected a rejection, got {other:?}"),
        }
    }

    #[test]
    fn a_3ds_review_is_a_rejection_not_a_capture() {
        let body = r#"{"user_message":"El usuario necesita autenticarse","action_code":"REVIEW"}"#;
        assert!(matches!(interpret_charge_response(200, body), Err(PaymentError::Rejected { .. })));
    }

    #[test]
    fn a_bad_key_is_our_bug_and_an_outage_is_retryable() {
        let auth = r#"{"object":"error","type":"authentication_error","merchant_message":"Llave inválida"}"#;
        assert!(matches!(interpret_charge_response(401, auth), Err(PaymentError::Internal(_))));
        assert!(matches!(interpret_charge_response(503, ""), Err(PaymentError::Unavailable)));
    }
}
