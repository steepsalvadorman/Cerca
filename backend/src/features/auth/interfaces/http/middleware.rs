use axum::extract::{FromRef, FromRequestParts};
use axum::http::request::Parts;
use axum::http::StatusCode;
use uuid::Uuid;

use crate::features::auth::domain::Role;
use crate::state::AppState;

/// Axum extractor that verifies the `Authorization: Bearer <token>`
/// header via the `TokenService` port and yields the caller's identity.
/// Any handler that takes `CurrentUser` as an argument is, by
/// construction, a protected route.
pub struct CurrentUser {
    pub user_id: Uuid,
    /// Not read yet — kept for role-gated routes future features will add.
    #[allow(dead_code)]
    pub role: Role,
}

impl<S> FromRequestParts<S> for CurrentUser
where
    AppState: FromRef<S>,
    S: Send + Sync,
{
    type Rejection = (StatusCode, &'static str);

    async fn from_request_parts(parts: &mut Parts, state: &S) -> Result<Self, Self::Rejection> {
        let app_state = AppState::from_ref(state);

        let header = parts
            .headers
            .get(axum::http::header::AUTHORIZATION)
            .and_then(|value| value.to_str().ok())
            .ok_or((StatusCode::UNAUTHORIZED, "missing authorization header"))?;

        let token = header
            .strip_prefix("Bearer ")
            .ok_or((StatusCode::UNAUTHORIZED, "expected a Bearer token"))?;

        let claims = app_state
            .token_service
            .verify(token)
            .map_err(|_| (StatusCode::UNAUTHORIZED, "invalid or expired token"))?;

        Ok(CurrentUser { user_id: claims.user_id, role: claims.role })
    }
}
