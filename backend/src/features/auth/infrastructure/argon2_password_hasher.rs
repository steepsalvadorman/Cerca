use argon2::password_hash::rand_core::OsRng;
use argon2::password_hash::SaltString;
use argon2::{Argon2, PasswordHash as Argon2Hash, PasswordHasher as Argon2HasherTrait, PasswordVerifier};

use crate::features::auth::application::PasswordHasher;

/// Argon2id-backed implementation of the `PasswordHasher` port.
pub struct Argon2PasswordHasher;

impl PasswordHasher for Argon2PasswordHasher {
    fn hash(&self, plain: &str) -> Result<String, ()> {
        let salt = SaltString::generate(&mut OsRng);
        Argon2::default()
            .hash_password(plain.as_bytes(), &salt)
            .map(|hash| hash.to_string())
            .map_err(|_| ())
    }

    fn verify(&self, plain: &str, hash: &str) -> Result<bool, ()> {
        let parsed = Argon2Hash::new(hash).map_err(|_| ())?;
        Ok(Argon2::default().verify_password(plain.as_bytes(), &parsed).is_ok())
    }
}
