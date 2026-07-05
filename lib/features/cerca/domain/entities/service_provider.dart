/// Common shape shared by an individual technician and a team ("equipo"),
/// mirroring the merged `selectedTech` object from the original prototype.
abstract class ServiceProvider {
  const ServiceProvider({
    required this.id,
    required this.name,
    required this.mono,
    required this.oficio,
    required this.rating,
    required this.distance,
    required this.priceLabel,
    required this.pinTop,
    required this.pinLeft,
    required this.reviews,
  });

  final int id;
  final String name;
  final String mono;
  final String oficio;
  final double rating;
  final String distance;
  final String priceLabel;
  final int reviews;

  /// Fractional (0.0-1.0) position of the map pin, matching the
  /// prototype's percentage-based `pinTop`/`pinLeft`.
  final double pinTop;
  final double pinLeft;

  bool get isTeam;
}

class Technician extends ServiceProvider {
  const Technician({
    required super.id,
    required super.name,
    required super.mono,
    required super.oficio,
    required super.rating,
    required super.distance,
    required super.priceLabel,
    required super.pinTop,
    required super.pinLeft,
    required super.reviews,
  });

  @override
  bool get isTeam => false;
}

class TechTeam extends ServiceProvider {
  const TechTeam({
    required super.id,
    required super.name,
    required super.mono,
    required super.oficio,
    required super.rating,
    required super.distance,
    required super.priceLabel,
    required super.pinTop,
    required super.pinLeft,
    required super.reviews,
    required this.crew,
    required this.projects,
    required this.laborCost,
    required this.materialsCost,
    required this.mobilityCost,
  });

  final int crew;
  final int projects;
  final int laborCost;
  final int materialsCost;
  final int mobilityCost;

  @override
  bool get isTeam => true;
}
