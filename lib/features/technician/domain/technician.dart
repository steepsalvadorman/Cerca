import 'package:freezed_annotation/freezed_annotation.dart';

part 'technician.freezed.dart';
part 'technician.g.dart';

/// Mirrors the backend's `TechnicianResponse` (see
/// `backend/src/features/technician/interfaces/http/dto.rs`).
@freezed
abstract class Technician with _$Technician {
  const factory Technician({
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
    required int coverageKm,
    required List<String> availableDays,
    required List<String> categories,
    required bool isVerified,
  }) = _Technician;

  factory Technician.fromJson(Map<String, dynamic> json) => _$TechnicianFromJson(json);
}
