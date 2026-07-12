// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobRequest _$JobRequestFromJson(Map<String, dynamic> json) => _JobRequest(
  id: json['id'] as String,
  clientId: json['client_id'] as String,
  technicianProfileId: (json['technician_profile_id'] as num?)?.toInt(),
  techTeamId: (json['tech_team_id'] as num?)?.toInt(),
  jobKind: json['job_kind'] as String,
  status: json['status'] as String,
  timelineStep: (json['timeline_step'] as num).toInt(),
  feeType: json['fee_type'] as String,
  feePaid: json['fee_paid'] as bool,
  paymentMethod: json['payment_method'] as String?,
  paymentDone: json['payment_done'] as bool,
  rating: (json['rating'] as num?)?.toInt(),
  title: json['title'] as String?,
  address: json['address'] as String?,
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$JobRequestToJson(_JobRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_id': instance.clientId,
      'technician_profile_id': instance.technicianProfileId,
      'tech_team_id': instance.techTeamId,
      'job_kind': instance.jobKind,
      'status': instance.status,
      'timeline_step': instance.timelineStep,
      'fee_type': instance.feeType,
      'fee_paid': instance.feePaid,
      'payment_method': instance.paymentMethod,
      'payment_done': instance.paymentDone,
      'rating': instance.rating,
      'title': instance.title,
      'address': instance.address,
      'comment': instance.comment,
    };
