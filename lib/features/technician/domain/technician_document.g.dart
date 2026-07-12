// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technician_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TechnicianDocumentStatus _$TechnicianDocumentStatusFromJson(
  Map<String, dynamic> json,
) => _TechnicianDocumentStatus(
  documentKey: json['document_key'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$TechnicianDocumentStatusToJson(
  _TechnicianDocumentStatus instance,
) => <String, dynamic>{
  'document_key': instance.documentKey,
  'status': instance.status,
};
