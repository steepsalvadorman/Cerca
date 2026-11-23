use axum::extract::State;
use axum::http::StatusCode;
use axum::Json;

use crate::features::auth::interfaces::http::middleware::TechnicianUser;
use crate::features::credits::application::{GetWalletUseCase, PurchaseCreditsInput, PurchaseCreditsUseCase};
use crate::features::credits::domain::CREDIT_PACKS;
use crate::shared::AppError;
use crate::state::AppState;

use super::dto::{CreditsOverviewResponse, PaymentsConfigResponse, PurchaseRequest, PurchaseResponse};

pub async fn get_credits(
    State(state): State<AppState>,
    current_user: TechnicianUser,
) -> Result<Json<CreditsOverviewResponse>, AppError> {
    let wallet = GetWalletUseCase::new(state.credit_repository.clone(), state.technician_repository.clone())
        .execute(current_user.user_id)
        .await?;
    Ok(Json(CreditsOverviewResponse {
        wallet: wallet.into(),
        packs: CREDIT_PACKS.iter().map(Into::into).collect(),
        payments: PaymentsConfigResponse {
            mode: state.payments_public.mode.clone(),
            culqi_public_key: state.payments_public.culqi_public_key.clone(),
        },
    }))
}

pub async fn purchase_credits(
    State(state): State<AppState>,
    current_user: TechnicianUser,
    Json(body): Json<PurchaseRequest>,
) -> Result<(StatusCode, Json<PurchaseResponse>), AppError> {
    let body = body.validated().map_err(AppError::Validation)?;

    // Culqi requires the payer's email; the account's is the one we trust.
    let email = state
        .user_repository
        .find_by_id(current_user.user_id)
        .await?
        .map(|user| user.email.as_str().to_string())
        .ok_or(AppError::Validation("usuario no encontrado".to_string()))?;

    let outcome = PurchaseCreditsUseCase::new(
        state.credit_repository.clone(),
        state.technician_repository.clone(),
        state.payment_gateway.clone(),
    )
    .execute(PurchaseCreditsInput {
        technician_user_id: current_user.user_id,
        email,
        purchase_id: body.purchase_id,
        pack_id: body.pack_id,
        source_id: body.source_id,
    })
    .await?;

    Ok((
        StatusCode::CREATED,
        Json(PurchaseResponse {
            status: outcome.status.as_str(),
            credits_added: outcome.credits_added,
            simulated: outcome.simulated,
            wallet: outcome.wallet.into(),
        }),
    ))
}
