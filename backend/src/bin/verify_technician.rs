//! Operator tool: approve or revoke a technician's verification after a
//! person has reviewed their identity documents.
//!
//! Verification is what lets a technician bid (`submit_offer.rs`), so it is
//! never granted automatically: confirming an upload only proves a file of
//! the right type exists (security audit run-1). Until there is an admin
//! panel, this is the review step.
//!
//! ```bash
//! cargo run --bin verify_technician -- --list            # profiles awaiting review
//! cargo run --bin verify_technician -- --profile-id 12   # approve
//! cargo run --bin verify_technician -- --profile-id 12 --revoke
//! ```
//!
//! Reads `DATABASE_URL` from the environment (or `.env`).

use backend::features::technician::domain::technician_document::MANDATORY_DOCUMENT_KEYS;
use sqlx::postgres::PgPoolOptions;

fn usage() -> ! {
    eprintln!("usage: verify_technician --list | --profile-id <id> [--revoke]");
    std::process::exit(2);
}

#[tokio::main]
async fn main() {
    let _ = dotenvy::dotenv();
    let args: Vec<String> = std::env::args().skip(1).collect();
    let database_url = std::env::var("DATABASE_URL").unwrap_or_else(|_| {
        eprintln!("DATABASE_URL is required");
        std::process::exit(2);
    });
    let pool = PgPoolOptions::new()
        .max_connections(1)
        .connect(&database_url)
        .await
        .expect("could not connect to the database");
    let mandatory: Vec<String> = MANDATORY_DOCUMENT_KEYS.iter().map(|k| k.to_string()).collect();

    if args.first().map(String::as_str) == Some("--list") {
        let rows: Vec<(i32, String, String)> = sqlx::query_as(
            "SELECT tp.id, u.name, u.email FROM technician_profiles tp JOIN users u ON u.id = tp.user_id \
             WHERE NOT tp.is_verified AND ( \
               SELECT COUNT(*) FROM technician_documents d \
               WHERE d.technician_profile_id = tp.id AND d.status = 'uploaded' AND d.document_key = ANY($1) \
             ) = cardinality($1) ORDER BY tp.id",
        )
        .bind(&mandatory)
        .fetch_all(&pool)
        .await
        .expect("query failed");
        if rows.is_empty() {
            println!("No technicians are awaiting review.");
        }
        for (id, name, email) in rows {
            println!("{id}\t{name}\t{email}");
        }
        return;
    }

    let profile_id: i32 = match args.as_slice() {
        [flag, id, ..] if flag == "--profile-id" => id.parse().unwrap_or_else(|_| usage()),
        _ => usage(),
    };
    let revoke = args.iter().any(|a| a == "--revoke");

    if !revoke {
        let (uploaded,): (i64,) = sqlx::query_as(
            "SELECT COUNT(*)::BIGINT FROM technician_documents \
             WHERE technician_profile_id = $1 AND status = 'uploaded' AND document_key = ANY($2)",
        )
        .bind(profile_id)
        .bind(&mandatory)
        .fetch_one(&pool)
        .await
        .expect("query failed");
        if uploaded < mandatory.len() as i64 {
            eprintln!(
                "Refusing: profile {profile_id} has {uploaded} of {} mandatory documents confirmed ({}).",
                mandatory.len(),
                mandatory.join(", ")
            );
            std::process::exit(1);
        }
    }

    let result = sqlx::query("UPDATE technician_profiles SET is_verified = $2 WHERE id = $1")
        .bind(profile_id)
        .bind(!revoke)
        .execute(&pool)
        .await
        .expect("update failed");
    if result.rows_affected() == 0 {
        eprintln!("No technician profile with id {profile_id}.");
        std::process::exit(1);
    }
    println!("Profile {profile_id}: is_verified = {}", !revoke);
}
