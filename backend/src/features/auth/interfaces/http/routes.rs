use axum::routing::{get, post};
use axum::Router;

use crate::state::AppState;

use super::handlers::{login, me, register};

pub fn auth_routes() -> Router<AppState> {
    Router::new()
        .route("/auth/register", post(register))
        .route("/auth/login", post(login))
        .route("/me", get(me))
}
