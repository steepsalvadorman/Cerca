use chrono::{Duration, Utc};
use jsonwebtoken::{decode, encode, Algorithm, DecodingKey, EncodingKey, Header, Validation};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::features::auth::application::{TokenClaims, TokenService};
use crate::features::auth::domain::Role;

#[derive(Serialize, Deserialize)]
struct Claims {
    sub: Uuid,
    role: String,
    exp: usize,
}

const SESSION_DAYS: i64 = 7;

/// JWT-backed implementation of the `TokenService` port.
pub struct JwtTokenService {
    encoding_key: EncodingKey,
    decoding_key: DecodingKey,
}

impl JwtTokenService {
    pub fn new(secret: &str) -> Self {
        Self {
            encoding_key: EncodingKey::from_secret(secret.as_bytes()),
            decoding_key: DecodingKey::from_secret(secret.as_bytes()),
        }
    }
}

impl TokenService for JwtTokenService {
    fn issue(&self, user_id: Uuid, role: Role) -> Result<String, ()> {
        let exp = (Utc::now() + Duration::days(SESSION_DAYS)).timestamp() as usize;
        let claims = Claims { sub: user_id, role: role.as_str().to_string(), exp };
        encode(&Header::new(Algorithm::HS256), &claims, &self.encoding_key).map_err(|_| ())
    }

    fn verify(&self, token: &str) -> Result<TokenClaims, ()> {
        let data = decode::<Claims>(token, &self.decoding_key, &Validation::new(Algorithm::HS256))
            .map_err(|_| ())?;
        let role = Role::parse(&data.claims.role).map_err(|_| ())?;
        Ok(TokenClaims { user_id: data.claims.sub, role })
    }
}
