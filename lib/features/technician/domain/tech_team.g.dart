// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tech_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TechTeam _$TechTeamFromJson(Map<String, dynamic> json) => _TechTeam(
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
  crew: (json['crew'] as num).toInt(),
  projects: (json['projects'] as num).toInt(),
  laborCost: (json['labor_cost'] as num).toInt(),
  materialsCost: (json['materials_cost'] as num).toInt(),
  mobilityCost: (json['mobility_cost'] as num).toInt(),
);

Map<String, dynamic> _$TechTeamToJson(_TechTeam instance) => <String, dynamic>{
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
  'crew': instance.crew,
  'projects': instance.projects,
  'labor_cost': instance.laborCost,
  'materials_cost': instance.materialsCost,
  'mobility_cost': instance.mobilityCost,
};
