use axum::routing::get;
use axum::Router;

use crate::state::AppState;

use super::handlers::{get_messages, send_message};

pub fn chat_routes() -> Router<AppState> {
    Router::new()
        .route("/jobs/{id}/messages", get(get_messages).post(send_message))
}
