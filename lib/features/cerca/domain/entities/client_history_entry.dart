enum ClientHistoryStatus { completed, cancelled }

/// One past request shown in the client's account history.
class ClientHistoryEntry {
  const ClientHistoryEntry({
    required this.category,
    required this.tech,
    required this.date,
    required this.status,
    required this.price,
  });

  final String category;
  final String tech;
  final String date;
  final ClientHistoryStatus status;
  final String price;
}
