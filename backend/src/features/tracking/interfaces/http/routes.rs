use axum::routing::get;
use axum::Router;

use crate::state::AppState;

use super::handlers::{get_location, update_location};

pub fn tracking_routes() -> Router<AppState> {
    Router::new()
        .route("/jobs/{id}/location", get(get_location).post(update_location))
}
