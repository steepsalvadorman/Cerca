//! Auth feature: registration, login and session verification.
//!
//! Layered by Clean Architecture / DDD, inner to outer:
//! `domain` (entities, value objects, repository port) is dependency-free;
//! `application` (use cases, technical ports) depends only on `domain`;
//! `infrastructure` (Postgres, argon2, JWT) implements the ports;
//! `interfaces::http` (axum handlers/DTOs/routes) is the only layer that
//! knows about HTTP.

pub mod application;
pub mod domain;
pub mod infrastructure;
pub mod interfaces;
