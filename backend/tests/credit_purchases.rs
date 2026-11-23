//! Technician credit packs through the real router (migration 0016).

use std::sync::Arc;

use axum::body::Body;
use axum::http::{Request, StatusCode};
use sqlx::PgPool;
use tower::ServiceExt;
use uuid::Uuid;

use backend::features::auth::application::TokenService;
use backend::features::auth::domain::Role;
use backend::features::auth::infrastructure::{
    Argon2PasswordHasher, JwtTokenService, PostgresUserRepository, UnconfiguredIdentityVerifier,
};
use backend::features::chat::infrastructure::PostgresChatRepository;
use backend::features::client::infrastructure::PostgresClientRepository;
use backend::features::credits::application::PaymentsPublicConfig;
use backend::features::credits::domain::WELCOME_CREDITS;
use backend::features::credits::infrastructure::PostgresCreditRepository;
use backend::features::job::infrastructure::{FakePaymentGateway, PostgresJobRepository, FAKE_DECLINED_TOKEN};
use backend::features::technician::infrastructure::{PostgresTechnicianRepository, UnconfiguredObjectStorage};
use backend::features::tracking::infrastructure::PostgresTrackingRepository;
use backend::routes::app_router;
use backend::state::AppState;

const TEST_JWT_SECRET: &str = "test-secret-for-credit-purchases";

fn test_state(pool: PgPool) -> AppState {
    AppState {
        user_repository: Arc::new(PostgresUserRepository::new(pool.clone())),
        password_hasher: Arc::new(Argon2PasswordHasher),
        token_service: Arc::new(JwtTokenService::new(TEST_JWT_SECRET)),
        identity_verifier: Arc::new(UnconfiguredIdentityVerifier),
        technician_repository: Arc::new(PostgresTechnicianRepository::new(pool.clone())),
        client_repository: Arc::new(PostgresClientRepository::new(pool.clone())),
        job_repository: Arc::new(PostgresJobRepository::new(pool.clone())),
        payment_gateway: Arc::new(FakePaymentGateway),
        credit_repository: Arc::new(PostgresCreditRepository::new(pool.clone())),
        payments_public: PaymentsPublicConfig { mode: "fake".to_string(), culqi_public_key: None },
        chat_repository: Arc::new(PostgresChatRepository::new(pool.clone())),
        tracking_repository: Arc::new(PostgresTrackingRepository::new(pool)),
        object_storage: Arc::new(UnconfiguredObjectStorage),
    }
}

async fn create_user(pool: &PgPool, role: &str) -> Uuid {
    let id = Uuid::new_v4();
    sqlx::query("INSERT INTO users (id, email, name, role, password_hash) VALUES ($1, $2, 'Test', $3, 'hash')")
        .bind(id)
        .bind(format!("{id}@test.local"))
        .bind(role)
        .execute(pool)
        .await
        .unwrap();
    id
}

async fn create_technician(pool: &PgPool) -> Uuid {
    let user_id = create_user(pool, "technician").await;
    sqlx::query(
        "INSERT INTO technician_profiles (user_id, oficio, pin_top, pin_left, is_verified) \
         VALUES ($1, 'Gasfitero', 0.5, 0.5, TRUE)",
    )
    .bind(user_id)
    .execute(pool)
    .await
    .unwrap();
    user_id
}

async fn call(pool: &PgPool, user_id: Uuid, role: Role, method: &str, uri: &str, body: Option<String>) -> (StatusCode, serde_json::Value) {
    let token = JwtTokenService::new(TEST_JWT_SECRET).issue(user_id, role).unwrap();
    let mut request = Request::builder()
        .method(method)
        .uri(uri)
        .header("Authorization", format!("Bearer {token}"));
    if body.is_some() {
        request = request.header("Content-Type", "application/json");
    }
    let response = app_router(test_state(pool.clone()), &[])
        .oneshot(request.body(body.map(Body::from).unwrap_or_else(Body::empty)).unwrap())
        .await
        .unwrap();
    let status = response.status();
    let bytes = axum::body::to_bytes(response.into_body(), usize::MAX).await.unwrap();
    (status, serde_json::from_slice(&bytes).unwrap_or(serde_json::Value::Null))
}

fn purchase_body(purchase_id: Uuid, pack_id: &str, source_id: &str) -> Option<String> {
    Some(format!(r#"{{"purchase_id":"{purchase_id}","pack_id":"{pack_id}","source_id":"{source_id}"}}"#))
}

#[sqlx::test(migrations = "./migrations")]
async fn a_new_technician_starts_with_the_welcome_credits_and_sees_the_packs(pool: PgPool) {
    let tech = create_technician(&pool).await;

    let (status, body) = call(&pool, tech, Role::Technician, "GET", "/technician/credits", None).await;

    assert_eq!(status, StatusCode::OK, "{body}");
    assert_eq!(body["wallet"]["available"], WELCOME_CREDITS);
    assert_eq!(body["payments"]["mode"], "fake");
    assert!(body["packs"].as_array().unwrap().iter().any(|p| p["id"] == "pack_5"));
}

#[sqlx::test(migrations = "./migrations")]
async fn buying_a_pack_adds_its_credits_once_even_when_retried(pool: PgPool) {
    let tech = create_technician(&pool).await;
    let purchase_id = Uuid::new_v4();

    let (first, body) = call(&pool, tech, Role::Technician, "POST", "/technician/credits/purchases",
        purchase_body(purchase_id, "pack_5", "tkn_test_anything")).await;
    assert_eq!(first, StatusCode::CREATED, "{body}");
    assert_eq!(body["status"], "paid");
    assert_eq!(body["credits_added"], 5);
    assert_eq!(body["simulated"], true);
    assert_eq!(body["wallet"]["balance"], WELCOME_CREDITS + 5);

    // An impatient double tap, or a retry after a dropped connection.
    let (second, body) = call(&pool, tech, Role::Technician, "POST", "/technician/credits/purchases",
        purchase_body(purchase_id, "pack_5", "tkn_test_anything")).await;
    assert_eq!(second, StatusCode::CREATED, "{body}");
    assert_eq!(body["wallet"]["balance"], WELCOME_CREDITS + 5, "credited twice");

    let (rows,): (i64,) = sqlx::query_as("SELECT COUNT(*) FROM credit_ledger WHERE purchase_id = $1")
        .bind(purchase_id)
        .fetch_one(&pool)
        .await
        .unwrap();
    assert_eq!(rows, 1);
}

#[sqlx::test(migrations = "./migrations")]
async fn a_declined_payment_adds_nothing_and_explains_why(pool: PgPool) {
    let tech = create_technician(&pool).await;

    let (status, body) = call(&pool, tech, Role::Technician, "POST", "/technician/credits/purchases",
        purchase_body(Uuid::new_v4(), "pack_12", FAKE_DECLINED_TOKEN)).await;

    assert_eq!(status, StatusCode::PAYMENT_REQUIRED, "{body}");
    assert!(body["error"].as_str().unwrap().contains("rechazada"), "{body}");

    let (_, body) = call(&pool, tech, Role::Technician, "GET", "/technician/credits", None).await;
    assert_eq!(body["wallet"]["balance"], WELCOME_CREDITS);
}

#[sqlx::test(migrations = "./migrations")]
async fn a_reused_purchase_id_for_another_pack_is_refused(pool: PgPool) {
    let tech = create_technician(&pool).await;
    let purchase_id = Uuid::new_v4();

    call(&pool, tech, Role::Technician, "POST", "/technician/credits/purchases",
        purchase_body(purchase_id, "pack_5", "tkn_test_anything")).await;
    let (status, _) = call(&pool, tech, Role::Technician, "POST", "/technician/credits/purchases",
        purchase_body(purchase_id, "pack_30", "tkn_test_anything")).await;

    assert_eq!(status, StatusCode::CONFLICT);
}

#[sqlx::test(migrations = "./migrations")]
async fn clients_have_no_credits(pool: PgPool) {
    let client = create_user(&pool, "client").await;

    let (status, _) = call(&pool, client, Role::Client, "GET", "/technician/credits", None).await;
    assert_eq!(status, StatusCode::FORBIDDEN);

    let (status, _) = call(&pool, client, Role::Client, "POST", "/technician/credits/purchases",
        purchase_body(Uuid::new_v4(), "pack_5", "tkn_test_anything")).await;
    assert_eq!(status, StatusCode::FORBIDDEN);
}
