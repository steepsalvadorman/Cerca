/// A saved address in the client's account.
class ClientAddress {
  const ClientAddress({required this.label, required this.detail});

  final String label;
  final String detail;
}

/// A saved payment method in the client's account.
class ClientPaymentMethod {
  const ClientPaymentMethod({required this.label, required this.detail});

  final String label;
  final String detail;
}
