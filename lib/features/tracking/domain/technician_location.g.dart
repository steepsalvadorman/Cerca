// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technician_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TechnicianLocation _$TechnicianLocationFromJson(Map<String, dynamic> json) =>
    _TechnicianLocation(
      jobRequestId: json['job_request_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$TechnicianLocationToJson(_TechnicianLocation instance) =>
    <String, dynamic>{
      'job_request_id': instance.jobRequestId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'updated_at': instance.updatedAt,
    };
