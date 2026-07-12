import 'package:freezed_annotation/freezed_annotation.dart';

part 'tech_team.freezed.dart';
part 'tech_team.g.dart';

/// Mirrors the backend's `TechTeamResponse`.
@freezed
abstract class TechTeam with _$TechTeam {
  const factory TechTeam({
    required int id,
    required String name,
    required String mono,
    required String oficio,
    required double rating,
    required int reviews,
    required String distance,
    required String priceLabel,
    required double pinTop,
    required double pinLeft,
    required int crew,
    required int projects,
    required int laborCost,
    required int materialsCost,
    required int mobilityCost,
  }) = _TechTeam;

  factory TechTeam.fromJson(Map<String, dynamic> json) => _$TechTeamFromJson(json);
}
