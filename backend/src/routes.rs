use axum::routing::get;
use axum::Router;
use tower_http::cors::CorsLayer;
use tower_http::trace::TraceLayer;

use crate::features::auth::interfaces::http::auth_routes;
use crate::features::technician::interfaces::http::technician_routes;
use crate::features::client::interfaces::http::client_routes;
use crate::features::job::interfaces::http::job_routes;
use crate::features::chat::interfaces::http::chat_routes;
use crate::features::tracking::interfaces::http::tracking_routes;
use crate::state::AppState;

async fn health() -> &'static str {
    "ok"
}

pub fn app_router(state: AppState) -> Router {
    Router::new()
        .route("/health", get(health))
        .merge(auth_routes())
        .merge(technician_routes())
        .merge(client_routes())
        .merge(job_routes())
        .merge(chat_routes())
        .merge(tracking_routes())
        .layer(TraceLayer::new_for_http())
        .layer(CorsLayer::permissive())
        .with_state(state)
}
