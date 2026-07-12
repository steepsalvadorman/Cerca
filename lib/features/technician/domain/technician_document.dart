import 'package:freezed_annotation/freezed_annotation.dart';

part 'technician_document.freezed.dart';
part 'technician_document.g.dart';

/// Mirrors the backend's `DocResponse`. `status` is `"uploaded"` or
/// `"pending"` (see the `technician_documents` table CHECK constraint).
@freezed
abstract class TechnicianDocumentStatus with _$TechnicianDocumentStatus {
  const factory TechnicianDocumentStatus({
    required String documentKey,
    required String status,
  }) = _TechnicianDocumentStatus;

  factory TechnicianDocumentStatus.fromJson(Map<String, dynamic> json) => _$TechnicianDocumentStatusFromJson(json);
}

extension TechnicianDocumentStatusX on TechnicianDocumentStatus {
  bool get isUploaded => status == 'uploaded';
}
