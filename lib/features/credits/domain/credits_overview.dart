/// A technician's credits. `available` already discounts the credits held
/// by offers waiting on open auctions (`reserved`).
class CreditWallet {
  const CreditWallet({required this.balance, required this.reserved, required this.available});

  final int balance;
  final int reserved;
  final int available;

  factory CreditWallet.fromJson(Map<String, dynamic> json) => CreditWallet(
        balance: (json['balance'] as num).toInt(),
        reserved: (json['reserved'] as num).toInt(),
        available: (json['available'] as num).toInt(),
      );
}

class CreditPack {
  const CreditPack({required this.id, required this.credits, required this.priceCents});

  final String id;
  final int credits;
  final int priceCents;

  double get priceSoles => priceCents / 100;
  double get pricePerCredit => priceSoles / credits;

  factory CreditPack.fromJson(Map<String, dynamic> json) => CreditPack(
        id: json['id'] as String,
        credits: (json['credits'] as num).toInt(),
        priceCents: (json['price_cents'] as num).toInt(),
      );
}

/// How payments are taken, as the backend is configured: `fake` simulates
/// (no money moves), `culqi` charges for real with [culqiPublicKey].
class PaymentsConfig {
  const PaymentsConfig({required this.mode, this.culqiPublicKey});

  final String mode;
  final String? culqiPublicKey;

  bool get isSimulated => mode == 'fake';
  bool get isCulqi => mode == 'culqi' && (culqiPublicKey?.isNotEmpty ?? false);
  bool get isAvailable => isSimulated || isCulqi;

  factory PaymentsConfig.fromJson(Map<String, dynamic> json) => PaymentsConfig(
        mode: json['mode'] as String? ?? '',
        culqiPublicKey: json['culqi_public_key'] as String?,
      );
}

class CreditsOverview {
  const CreditsOverview({required this.wallet, required this.packs, required this.payments});

  final CreditWallet wallet;
  final List<CreditPack> packs;
  final PaymentsConfig payments;

  factory CreditsOverview.fromJson(Map<String, dynamic> json) => CreditsOverview(
        wallet: CreditWallet.fromJson(json['wallet'] as Map<String, dynamic>),
        packs: (json['packs'] as List).map((e) => CreditPack.fromJson(e as Map<String, dynamic>)).toList(),
        payments: PaymentsConfig.fromJson(json['payments'] as Map<String, dynamic>),
      );
}

class PurchaseResult {
  const PurchaseResult({required this.creditsAdded, required this.simulated, required this.wallet});

  final int creditsAdded;
  final bool simulated;
  final CreditWallet wallet;

  factory PurchaseResult.fromJson(Map<String, dynamic> json) => PurchaseResult(
        creditsAdded: (json['credits_added'] as num).toInt(),
        simulated: json['simulated'] as bool? ?? false,
        wallet: CreditWallet.fromJson(json['wallet'] as Map<String, dynamic>),
      );
}
