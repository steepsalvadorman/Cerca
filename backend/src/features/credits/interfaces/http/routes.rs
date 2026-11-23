use axum::routing::{get, post};
use axum::Router;

use crate::state::AppState;

use super::handlers::{get_credits, purchase_credits};

pub fn credit_routes() -> Router<AppState> {
    Router::new()
        .route("/technician/credits", get(get_credits))
        .route("/technician/credits/purchases", post(purchase_credits))
}
