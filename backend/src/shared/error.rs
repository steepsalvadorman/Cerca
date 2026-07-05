use axum::http::StatusCode;
use axum::response::{IntoResponse, Response};
use axum::Json;
use serde_json::json;

use crate::features::auth::domain::AuthError;

/// Root HTTP error type. Each feature's domain error gets a `From` impl
/// here so handlers can just use `?` and the interfaces layer stays the
/// only place that knows about status codes.
pub enum AppError {
    Auth(AuthError),
}

impl From<AuthError> for AppError {
    fn from(error: AuthError) -> Self {
        AppError::Auth(error)
    }
}

impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        let (status, public_message) = match &self {
            AppError::Auth(AuthError::EmailAlreadyExists) => (StatusCode::CONFLICT, self.to_string()),
            AppError::Auth(AuthError::InvalidCredentials) => (StatusCode::UNAUTHORIZED, self.to_string()),
            AppError::Auth(AuthError::InvalidEmail)
            | AppError::Auth(AuthError::InvalidRole)
            | AppError::Auth(AuthError::WeakPassword) => (StatusCode::BAD_REQUEST, self.to_string()),
            AppError::Auth(AuthError::Hashing)
            | AppError::Auth(AuthError::Token)
            | AppError::Auth(AuthError::Repository(_)) => {
                tracing::error!(error = %self, "internal error handling request");
                (StatusCode::INTERNAL_SERVER_ERROR, "internal server error".to_string())
            }
        };

        (status, Json(json!({ "error": public_message }))).into_response()
    }
}

impl std::fmt::Display for AppError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            AppError::Auth(e) => write!(f, "{e}"),
        }
    }
}
