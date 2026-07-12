use axum::routing::{get, post};
use axum::Router;

use crate::state::AppState;

use super::handlers::{
    add_address, add_payment_method, get_addresses, get_payment_methods, get_profile_status, save_profile,
};

pub fn client_routes() -> Router<AppState> {
    Router::new()
        .route("/client/profile", post(save_profile).get(get_profile_status))
        .route("/client/addresses", get(get_addresses).post(add_address))
        .route("/client/payment-methods", get(get_payment_methods).post(add_payment_method))
}
