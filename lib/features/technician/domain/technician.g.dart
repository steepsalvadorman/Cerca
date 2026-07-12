// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technician.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Technician _$TechnicianFromJson(Map<String, dynamic> json) => _Technician(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  mono: json['mono'] as String,
  oficio: json['oficio'] as String,
  rating: (json['rating'] as num).toDouble(),
  reviews: (json['reviews'] as num).toInt(),
  distance: json['distance'] as String,
  priceLabel: json['price_label'] as String,
  pinTop: (json['pin_top'] as num).toDouble(),
  pinLeft: (json['pin_left'] as num).toDouble(),
  coverageKm: (json['coverage_km'] as num).toInt(),
  availableDays: (json['available_days'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  categories: (json['categories'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  isVerified: json['is_verified'] as bool,
);

Map<String, dynamic> _$TechnicianToJson(_Technician instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mono': instance.mono,
      'oficio': instance.oficio,
      'rating': instance.rating,
      'reviews': instance.reviews,
      'distance': instance.distance,
      'price_label': instance.priceLabel,
      'pin_top': instance.pinTop,
      'pin_left': instance.pinLeft,
      'coverage_km': instance.coverageKm,
      'available_days': instance.availableDays,
      'categories': instance.categories,
      'is_verified': instance.isVerified,
    };
