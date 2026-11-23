//! Regression tests for the findings of security audit run-1, through the
//! real router. Each test names the finding fingerprint it pins.

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
use backend::features::credits::domain::{OPEN_AUCTION_TTL_DAYS, WELCOME_CREDITS};
use backend::features::credits::infrastructure::PostgresCreditRepository;
use backend::features::job::application::MAX_OPEN_JOBS_PER_CLIENT;
use backend::features::job::application::PaymentGateway;
use backend::features::job::infrastructure::{FakePaymentGateway, PostgresJobRepository, UnconfiguredPaymentGateway};
use backend::features::technician::infrastructure::{PostgresTechnicianRepository, UnconfiguredObjectStorage};
use backend::features::tracking::infrastructure::PostgresTrackingRepository;
use backend::routes::app_router;
use backend::state::AppState;

const SECRET: &str = "test-secret-for-security-audit-fixes";

fn state_with(pool: PgPool, payments: Arc<dyn PaymentGateway>) -> AppState {
    AppState {
        user_repository: Arc::new(PostgresUserRepository::new(pool.clone())),
        password_hasher: Arc::new(Argon2PasswordHasher),
        token_service: Arc::new(JwtTokenService::new(SECRET)),
        identity_verifier: Arc::new(UnconfiguredIdentityVerifier),
        technician_repository: Arc::new(PostgresTechnicianRepository::new(pool.clone())),
        client_repository: Arc::new(PostgresClientRepository::new(pool.clone())),
        job_repository: Arc::new(PostgresJobRepository::new(pool.clone())),
        payment_gateway: payments,
        credit_repository: Arc::new(PostgresCreditRepository::new(pool.clone())),
        payments_public: PaymentsPublicConfig { mode: "fake".to_string(), culqi_public_key: None },
        chat_repository: Arc::new(PostgresChatRepository::new(pool.clone())),
        tracking_repository: Arc::new(PostgresTrackingRepository::new(pool)),
        object_storage: Arc::new(UnconfiguredObjectStorage),
    }
}

async fn user(pool: &PgPool, role: &str) -> Uuid {
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

async fn technician(pool: &PgPool) -> (Uuid, i32) {
    let user_id = user(pool, "technician").await;
    let (id,): (i32,) = sqlx::query_as(
        "INSERT INTO technician_profiles (user_id, oficio, pin_top, pin_left, is_verified) \
         VALUES ($1, 'Gasfitero', 0.5, 0.5, TRUE) RETURNING id",
    )
    .bind(user_id)
    .fetch_one(pool)
    .await
    .unwrap();
    (user_id, id)
}

async fn call_with(
    state: AppState,
    who: Uuid,
    role: Role,
    method: &str,
    uri: &str,
    body: Option<String>,
) -> (StatusCode, serde_json::Value) {
    let token = JwtTokenService::new(SECRET).issue(who, role).unwrap();
    let mut req = Request::builder().method(method).uri(uri).header("Authorization", format!("Bearer {token}"));
    if body.is_some() {
        req = req.header("Content-Type", "application/json");
    }
    let resp = app_router(state, &[])
        .oneshot(req.body(body.map(Body::from).unwrap_or_else(Body::empty)).unwrap())
        .await
        .unwrap();
    let status = resp.status();
    let bytes = axum::body::to_bytes(resp.into_body(), usize::MAX).await.unwrap();
    (status, serde_json::from_slice(&bytes).unwrap_or(serde_json::Value::Null))
}

async fn call(pool: &PgPool, who: Uuid, role: Role, method: &str, uri: &str, body: Option<String>) -> (StatusCode, serde_json::Value) {
    call_with(state_with(pool.clone(), Arc::new(FakePaymentGateway)), who, role, method, uri, body).await
}

async fn create_job(pool: &PgPool, client: Uuid, body: &str) -> Uuid {
    let (status, json) = call(pool, client, Role::Client, "POST", "/jobs", Some(body.to_string())).await;
    assert_eq!(status, StatusCode::CREATED, "{json}");
    json["id"].as_str().unwrap().parse().unwrap()
}

async fn balance(pool: &PgPool, profile_id: i32) -> i64 {
    let (b,): (i64,) = sqlx::query_as("SELECT COALESCE(SUM(delta),0)::BIGINT FROM credit_ledger WHERE technician_profile_id = $1")
        .bind(profile_id)
        .fetch_one(pool)
        .await
        .unwrap();
    b
}

async fn status_of(pool: &PgPool, job: Uuid) -> String {
    let (s,): (String,) = sqlx::query_as("SELECT status FROM job_requests WHERE id = $1").bind(job).fetch_one(pool).await.unwrap();
    s
}

/// backend/src/features/job/application/mod.rs:GetJobOffersUseCase:non-owner-offer-disclosure
#[sqlx::test(migrations = "./migrations")]
async fn only_the_owning_client_sees_the_offers(pool: PgPool) {
    let client = user(&pool, "client").await;
    let (bidder, _) = technician(&pool).await;
    let (rival, _) = technician(&pool).await;
    let job = create_job(&pool, client, r#"{"job_kind":"bidding","title":"Fuga"}"#).await;
    let (s, _) = call(&pool, bidder, Role::Technician, "POST", &format!("/jobs/{job}/offers"), Some(r#"{"price":100,"eta":"Hoy"}"#.into())).await;
    assert_eq!(s, StatusCode::CREATED);

    let (s, _) = call(&pool, rival, Role::Technician, "GET", &format!("/jobs/{job}/offers"), None).await;
    assert_eq!(s, StatusCode::FORBIDDEN, "a rival technician must not read competing bids");
    let (s, json) = call(&pool, client, Role::Client, "GET", &format!("/jobs/{job}/offers"), None).await;
    assert_eq!(s, StatusCode::OK);
    assert_eq!(json.as_array().unwrap().len(), 1);
}

/// job/create_job:direct-hire-sockpuppet-rating-inflation and
/// job:create_job:unbounded-victim-directed-job-accumulation
#[sqlx::test(migrations = "./migrations")]
async fn a_direct_hire_waits_for_the_technician_who_pays_a_credit_or_declines(pool: PgPool) {
    let client = user(&pool, "client").await;
    let (tech, profile) = technician(&pool).await;
    let (other, _) = technician(&pool).await;
    let body = format!(r#"{{"job_kind":"direct","technician_profile_id":{profile}}}"#);

    let job = create_job(&pool, client, &body).await;
    assert_eq!(status_of(&pool, job).await, "pending", "no consent, no running job");
    let (s, _) = call(&pool, tech, Role::Technician, "POST", &format!("/jobs/{job}/advance"), None).await;
    assert_ne!(s, StatusCode::OK, "cannot work an unaccepted job");
    let (s, _) = call(&pool, other, Role::Technician, "POST", &format!("/jobs/{job}/accept"), None).await;
    assert_eq!(s, StatusCode::FORBIDDEN, "only the named technician answers");

    let (s, _) = call(&pool, tech, Role::Technician, "POST", &format!("/jobs/{job}/accept"), None).await;
    assert_eq!(s, StatusCode::OK);
    assert_eq!(status_of(&pool, job).await, "active");
    assert_eq!(balance(&pool, profile).await, WELCOME_CREDITS as i64 - 1, "acceptance costs one credit");

    let unwanted = create_job(&pool, client, &body).await;
    let (s, _) = call(&pool, tech, Role::Technician, "POST", &format!("/jobs/{unwanted}/decline"), None).await;
    assert_eq!(s, StatusCode::OK);
    assert_eq!(status_of(&pool, unwanted).await, "cancelled");
    assert_eq!(balance(&pool, profile).await, WELCOME_CREDITS as i64 - 1, "declining is free");
}

/// job/create_job:direct-hire-sockpuppet-rating-inflation
#[sqlx::test(migrations = "./migrations")]
async fn one_client_counts_once_in_a_technicians_rating(pool: PgPool) {
    let honest = user(&pool, "client").await;
    let puppet = user(&pool, "client").await;
    let (tech, profile) = technician(&pool).await;
    let body = format!(r#"{{"job_kind":"direct","technician_profile_id":{profile}}}"#);

    let rate = |client: Uuid, stars: i32| {
        let pool = pool.clone();
        let body = body.clone();
        async move {
            let job = create_job(&pool, client, &body).await;
            call(&pool, tech, Role::Technician, "POST", &format!("/jobs/{job}/accept"), None).await;
            for _ in 0..3 {
                call(&pool, tech, Role::Technician, "POST", &format!("/jobs/{job}/advance"), None).await;
            }
            let (s, _) = call(&pool, client, Role::Client, "POST", &format!("/jobs/{job}/rate"), Some(format!(r#"{{"rating":{stars}}}"#))).await;
            assert_eq!(s, StatusCode::OK);
        }
    };
    rate(honest, 1).await;
    rate(puppet, 5).await;
    rate(puppet, 5).await;

    let (rating, reviews): (f64, i32) = sqlx::query_as("SELECT rating, reviews FROM technician_profiles WHERE id = $1")
        .bind(profile)
        .fetch_one(&pool)
        .await
        .unwrap();
    assert_eq!(reviews, 2, "two distinct clients, two votes");
    assert!((rating - 3.0).abs() < 1e-9, "average of 1 and 5, not of 1,5,5: {rating}");
}

/// credits:submit-offer-credit-reservation-toctou
#[sqlx::test(migrations = "./migrations")]
async fn concurrent_offers_cannot_spend_more_credits_than_exist(pool: PgPool) {
    let client = user(&pool, "client").await;
    let (tech, profile) = technician(&pool).await;
    let mut jobs = Vec::new();
    for _ in 0..(WELCOME_CREDITS + 3) {
        jobs.push(create_job(&pool, client, r#"{"job_kind":"bidding","title":"x"}"#).await);
    }
    let tasks = jobs.into_iter().map(|job| {
        let pool = pool.clone();
        tokio::spawn(async move {
            call(&pool, tech, Role::Technician, "POST", &format!("/jobs/{job}/offers"), Some(r#"{"price":50,"eta":"Hoy"}"#.into())).await.0
        })
    });
    let results: Vec<StatusCode> = futures_join(tasks).await;
    let accepted = results.iter().filter(|s| **s == StatusCode::CREATED).count();
    assert_eq!(accepted, WELCOME_CREDITS as usize, "{results:?}");
    let (open,): (i64,) = sqlx::query_as("SELECT COUNT(*)::BIGINT FROM job_offers WHERE technician_profile_id = $1")
        .bind(profile)
        .fetch_one(&pool)
        .await
        .unwrap();
    assert!(open <= balance(&pool, profile).await, "open offers never exceed the balance");
}

async fn futures_join<T: Send + 'static>(tasks: impl Iterator<Item = tokio::task::JoinHandle<T>>) -> Vec<T> {
    let mut out = Vec::new();
    for t in tasks.collect::<Vec<_>>() {
        out.push(t.await.unwrap());
    }
    out
}

/// backend/src/features/job/application/cancel_job.rs:client-uncompensated-credit-burn-and-lock
#[sqlx::test(migrations = "./migrations")]
async fn cancelling_before_work_gives_the_technician_their_credit_back(pool: PgPool) {
    let client = user(&pool, "client").await;
    let (tech, profile) = technician(&pool).await;
    let job = create_job(&pool, client, r#"{"job_kind":"bidding","title":"Fuga"}"#).await;
    call(&pool, tech, Role::Technician, "POST", &format!("/jobs/{job}/offers"), Some(r#"{"price":80,"eta":"Hoy"}"#.into())).await;
    let (offer_id,): (i32,) = sqlx::query_as("SELECT id FROM job_offers WHERE job_request_id = $1").bind(job).fetch_one(&pool).await.unwrap();
    let (s, _) = call(&pool, client, Role::Client, "POST", &format!("/jobs/{job}/offers/choose"), Some(format!(r#"{{"offer_id":{offer_id}}}"#))).await;
    assert_eq!(s, StatusCode::OK);
    assert_eq!(balance(&pool, profile).await, WELCOME_CREDITS as i64 - 1);

    for _ in 0..2 {
        call(&pool, client, Role::Client, "POST", &format!("/jobs/{job}/cancel"), Some("{}".into())).await;
    }
    assert_eq!(balance(&pool, profile).await, WELCOME_CREDITS as i64, "refunded exactly once");
}

/// backend/src/features/job/application/cancel_job.rs:client-uncompensated-credit-burn-and-lock
#[sqlx::test(migrations = "./migrations")]
async fn an_expired_auction_releases_credits_and_takes_no_offers(pool: PgPool) {
    let client = user(&pool, "client").await;
    let (tech, _) = technician(&pool).await;
    let job = create_job(&pool, client, r#"{"job_kind":"bidding","title":"Fuga"}"#).await;
    call(&pool, tech, Role::Technician, "POST", &format!("/jobs/{job}/offers"), Some(r#"{"price":80,"eta":"Hoy"}"#.into())).await;
    let (_, before) = call(&pool, tech, Role::Technician, "GET", "/technician/credits", None).await;
    assert_eq!(before["wallet"]["reserved"], 1);

    sqlx::query("UPDATE job_requests SET created_at = now() - make_interval(days => $2) WHERE id = $1")
        .bind(job)
        .bind(OPEN_AUCTION_TTL_DAYS + 1)
        .execute(&pool)
        .await
        .unwrap();
    let (_, after) = call(&pool, tech, Role::Technician, "GET", "/technician/credits", None).await;
    assert_eq!(after["wallet"]["reserved"], 0, "an expired auction holds nothing back");

    let (late, _) = technician(&pool).await;
    let (s, _) = call(&pool, late, Role::Technician, "POST", &format!("/jobs/{job}/offers"), Some(r#"{"price":70,"eta":"Hoy"}"#.into())).await;
    assert_eq!(s, StatusCode::BAD_REQUEST);
}

/// job:create_job:unbounded-victim-directed-job-accumulation
#[sqlx::test(migrations = "./migrations")]
async fn a_client_cannot_hold_unlimited_open_jobs(pool: PgPool) {
    let client = user(&pool, "client").await;
    for _ in 0..MAX_OPEN_JOBS_PER_CLIENT {
        create_job(&pool, client, r#"{"job_kind":"bidding","title":"x"}"#).await;
    }
    let (s, _) = call(&pool, client, Role::Client, "POST", "/jobs", Some(r#"{"job_kind":"bidding","title":"x"}"#.into())).await;
    assert_eq!(s, StatusCode::TOO_MANY_REQUESTS);
}

/// credits:purchase-retry-error-conflation
#[sqlx::test(migrations = "./migrations")]
async fn an_uncertain_psp_failure_is_never_reported_as_a_decline_or_charged_twice(pool: PgPool) {
    let (tech, _) = technician(&pool).await;
    let purchase = Uuid::new_v4();
    let body = format!(r#"{{"purchase_id":"{purchase}","pack_id":"pack_5","source_id":"tkn_test_x"}}"#);
    let down = || state_with(pool.clone(), Arc::new(UnconfiguredPaymentGateway));

    let (s, _) = call_with(down(), tech, Role::Technician, "POST", "/technician/credits/purchases", Some(body.clone())).await;
    assert_eq!(s, StatusCode::SERVICE_UNAVAILABLE);
    let (status,): (String,) = sqlx::query_as("SELECT status FROM credit_purchases WHERE id = $1").bind(purchase).fetch_one(&pool).await.unwrap();
    assert_eq!(status, "pending", "unknown outcome stays pending for reconciliation");

    // Even with the PSP back up, the same key is not charged again.
    let (s, json) = call(&pool, tech, Role::Technician, "POST", "/technician/credits/purchases", Some(body)).await;
    assert_eq!(s, StatusCode::CONFLICT, "{json}");
}
