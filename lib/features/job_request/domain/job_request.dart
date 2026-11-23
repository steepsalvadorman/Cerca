import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_request.freezed.dart';
part 'job_request.g.dart';

/// Mirrors the backend's `JobRequestResponse`.
///
/// The backend also answers with a trimmed `OpenBidJobResponse` (id, kind,
/// status, title, created_at) when a technician looks at an auction they
/// are not part of — in `/technician/jobs` → `open_for_bid` and in
/// `GET /jobs/{id}`. The fields that view leaves out carry defaults here
/// so one model parses both shapes instead of failing the whole inbox.
@freezed
abstract class JobRequest with _$JobRequest {
  const factory JobRequest({
    required String id,
    String? clientId,
    int? technicianProfileId,
    int? techTeamId,
    required String jobKind,
    required String status,
    @Default(0) int timelineStep,
    @Default('') String feeType,
    @Default(0) int feeAmount,
    @Default(false) bool feePaid,
    String? paymentMethod,
    @Default(false) bool paymentDone,
    @Default(false) bool mobilityIncluded,
    int? agreedPrice,
    int? rating,
    String? title,
    String? address,
    String? comment,
    required String createdAt,
  }) = _JobRequest;

  factory JobRequest.fromJson(Map<String, dynamic> json) => _$JobRequestFromJson(json);
}

extension JobRequestX on JobRequest {
  bool get isPending => status == 'pending';
  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  /// Backend allows sending messages only while the job is pending or active.
  bool get isChatWritable => isPending || isActive;

  /// User-facing status, never the raw backend value.
  String get statusLabel => switch (status) {
        'pending' => 'Pendiente',
        'active' => 'En curso',
        'completed' => 'Completado',
        'cancelled' => 'Cancelado',
        _ => status,
      };

  /// User-facing hiring mode, never the raw backend value.
  String get kindLabel => switch (jobKind) {
        'direct' => 'Contacto directo',
        'bidding' => 'Licitación',
        'project' => 'Proyecto',
        _ => jobKind,
      };
}
