/// What the app needs to know to take a payment: whether money is real,
/// and the PSP's *public* key to create tokens with. Served by the API so
/// switching Culqi from test to live keys needs no app release.
#[derive(Debug, Clone)]
pub struct PaymentsPublicConfig {
    /// `"fake"` (simulated, dev only), `"culqi"`, or anything else meaning
    /// payments are off.
    pub mode: String,
    pub culqi_public_key: Option<String>,
}
