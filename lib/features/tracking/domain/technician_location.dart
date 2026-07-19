import 'package:freezed_annotation/freezed_annotation.dart';

part 'technician_location.freezed.dart';
part 'technician_location.g.dart';

/// Mirrors the backend's `LocationResponse`.
@freezed
abstract class TechnicianLocation with _$TechnicianLocation {
  const factory TechnicianLocation({
    required String jobRequestId,
    required double latitude,
    required double longitude,
    required String updatedAt,
  }) = _TechnicianLocation;

  factory TechnicianLocation.fromJson(Map<String, dynamic> json) => _$TechnicianLocationFromJson(json);
}
