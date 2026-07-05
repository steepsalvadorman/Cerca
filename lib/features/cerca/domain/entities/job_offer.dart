/// A bid received from a technician during the "licitación" flow.
class JobOffer {
  const JobOffer({
    required this.id,
    required this.name,
    required this.mono,
    required this.oficio,
    required this.rating,
    required this.price,
    required this.eta,
    required this.verified,
  });

  final int id;
  final String name;
  final String mono;
  final String oficio;
  final double rating;
  final int price;
  final String eta;
  final bool verified;
}
