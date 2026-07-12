use axum::routing::{get, post};
use axum::Router;

use crate::state::AppState;

use super::handlers::{get_documents, get_my_profile, get_providers, save_profile, toggle_document};

pub fn technician_routes() -> Router<AppState> {
    Router::new()
        .route("/providers", get(get_providers))
        .route("/technician/profile", get(get_my_profile).post(save_profile))
        .route("/technician/documents", get(get_documents))
        .route("/technician/documents/toggle", post(toggle_document))
}
