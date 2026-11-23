/// A pack a technician can buy. Prices are in céntimos (Culqi's unit).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct CreditPack {
    pub id: &'static str,
    pub credits: i32,
    pub price_cents: i32,
}

impl CreditPack {
    pub fn find(id: &str) -> Option<&'static CreditPack> {
        CREDIT_PACKS.iter().find(|pack| pack.id == id)
    }
}

/// PLACEHOLDER PRICING: a starting point (S/ 4 per credit, cheaper in
/// bulk), not a validated commercial decision. Confirm with real PSP fees
/// and technician feedback before launch. Packs stay above the PSP's
/// minimum commission threshold so the fixed fee is paid once per pack,
/// not once per job.
pub const CREDIT_PACKS: &[CreditPack] = &[
    CreditPack { id: "pack_5", credits: 5, price_cents: 2_000 },
    CreditPack { id: "pack_12", credits: 12, price_cents: 4_500 },
    CreditPack { id: "pack_30", credits: 30, price_cents: 10_000 },
];

/// Granted once per technician, the first time their wallet is read, so a
/// new technician can win their first jobs before paying anything.
pub const WELCOME_CREDITS: i32 = 3;
