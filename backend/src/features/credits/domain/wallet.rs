/// A technician's credits.
///
/// `reserved` counts offers still waiting on an open auction: each could
/// be picked and cost a credit, so they are held back from `available`.
/// Requiring `available >= 1` to bid is what keeps the balance from ever
/// going negative when several offers win at once — and means a client is
/// never refused the offer they picked.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Wallet {
    pub balance: i64,
    pub reserved: i64,
}

impl Wallet {
    pub fn available(&self) -> i64 {
        (self.balance - self.reserved).max(0)
    }

    pub fn can_bid(&self) -> bool {
        self.available() >= 1
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn open_offers_hold_credits_back() {
        let wallet = Wallet { balance: 3, reserved: 2 };
        assert_eq!(wallet.available(), 1);
        assert!(wallet.can_bid());

        let full = Wallet { balance: 3, reserved: 3 };
        assert_eq!(full.available(), 0);
        assert!(!full.can_bid());
    }

    #[test]
    fn available_never_goes_negative() {
        assert_eq!(Wallet { balance: 1, reserved: 4 }.available(), 0);
    }
}
