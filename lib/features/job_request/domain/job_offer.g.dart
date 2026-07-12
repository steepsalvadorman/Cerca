// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobOffer _$JobOfferFromJson(Map<String, dynamic> json) => _JobOffer(
  id: (json['id'] as num).toInt(),
  jobRequestId: json['job_request_id'] as String,
  technicianProfileId: (json['technician_profile_id'] as num).toInt(),
  price: (json['price'] as num).toInt(),
  eta: json['eta'] as String,
  name: json['name'] as String,
  mono: json['mono'] as String,
  oficio: json['oficio'] as String,
  rating: (json['rating'] as num).toDouble(),
  verified: json['verified'] as bool,
);

Map<String, dynamic> _$JobOfferToJson(_JobOffer instance) => <String, dynamic>{
  'id': instance.id,
  'job_request_id': instance.jobRequestId,
  'technician_profile_id': instance.technicianProfileId,
  'price': instance.price,
  'eta': instance.eta,
  'name': instance.name,
  'mono': instance.mono,
  'oficio': instance.oficio,
  'rating': instance.rating,
  'verified': instance.verified,
};
