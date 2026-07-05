use axum::routing::get;
use axum::Router;
use tower_http::trace::TraceLayer;

use crate::features::auth::interfaces::http::auth_routes;
use crate::state::AppState;

async fn health() -> &'static str {
    "ok"
}

pub fn app_router(state: AppState) -> Router {
    Router::new()
        .route("/health", get(health))
        .merge(auth_routes())
        .layer(TraceLayer::new_for_http())
        .with_state(state)
}
