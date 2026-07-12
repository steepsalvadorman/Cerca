// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tech_team.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TechTeam {

 int get id; String get name; String get mono; String get oficio; double get rating; int get reviews; String get distance; String get priceLabel; double get pinTop; double get pinLeft; int get crew; int get projects; int get laborCost; int get materialsCost; int get mobilityCost;
/// Create a copy of TechTeam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechTeamCopyWith<TechTeam> get copyWith => _$TechTeamCopyWithImpl<TechTeam>(this as TechTeam, _$identity);

  /// Serializes this TechTeam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechTeam&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mono, mono) || other.mono == mono)&&(identical(other.oficio, oficio) || other.oficio == oficio)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviews, reviews) || other.reviews == reviews)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&(identical(other.pinTop, pinTop) || other.pinTop == pinTop)&&(identical(other.pinLeft, pinLeft) || other.pinLeft == pinLeft)&&(identical(other.crew, crew) || other.crew == crew)&&(identical(other.projects, projects) || other.projects == projects)&&(identical(other.laborCost, laborCost) || other.laborCost == laborCost)&&(identical(other.materialsCost, materialsCost) || other.materialsCost == materialsCost)&&(identical(other.mobilityCost, mobilityCost) || other.mobilityCost == mobilityCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mono,oficio,rating,reviews,distance,priceLabel,pinTop,pinLeft,crew,projects,laborCost,materialsCost,mobilityCost);

@override
String toString() {
  return 'TechTeam(id: $id, name: $name, mono: $mono, oficio: $oficio, rating: $rating, reviews: $reviews, distance: $distance, priceLabel: $priceLabel, pinTop: $pinTop, pinLeft: $pinLeft, crew: $crew, projects: $projects, laborCost: $laborCost, materialsCost: $materialsCost, mobilityCost: $mobilityCost)';
}


}

/// @nodoc
abstract mixin class $TechTeamCopyWith<$Res>  {
  factory $TechTeamCopyWith(TechTeam value, $Res Function(TechTeam) _then) = _$TechTeamCopyWithImpl;
@useResult
$Res call({
 int id, String name, String mono, String oficio, double rating, int reviews, String distance, String priceLabel, double pinTop, double pinLeft, int crew, int projects, int laborCost, int materialsCost, int mobilityCost
});




}
/// @nodoc
class _$TechTeamCopyWithImpl<$Res>
    implements $TechTeamCopyWith<$Res> {
  _$TechTeamCopyWithImpl(this._self, this._then);

  final TechTeam _self;
  final $Res Function(TechTeam) _then;

/// Create a copy of TechTeam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? mono = null,Object? oficio = null,Object? rating = null,Object? reviews = null,Object? distance = null,Object? priceLabel = null,Object? pinTop = null,Object? pinLeft = null,Object? crew = null,Object? projects = null,Object? laborCost = null,Object? materialsCost = null,Object? mobilityCost = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mono: null == mono ? _self.mono : mono // ignore: cast_nullable_to_non_nullable
as String,oficio: null == oficio ? _self.oficio : oficio // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as int,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as String,priceLabel: null == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String,pinTop: null == pinTop ? _self.pinTop : pinTop // ignore: cast_nullable_to_non_nullable
as double,pinLeft: null == pinLeft ? _self.pinLeft : pinLeft // ignore: cast_nullable_to_non_nullable
as double,crew: null == crew ? _self.crew : crew // ignore: cast_nullable_to_non_nullable
as int,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as int,laborCost: null == laborCost ? _self.laborCost : laborCost // ignore: cast_nullable_to_non_nullable
as int,materialsCost: null == materialsCost ? _self.materialsCost : materialsCost // ignore: cast_nullable_to_non_nullable
as int,mobilityCost: null == mobilityCost ? _self.mobilityCost : mobilityCost // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TechTeam].
extension TechTeamPatterns on TechTeam {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechTeam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechTeam() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechTeam value)  $default,){
final _that = this;
switch (_that) {
case _TechTeam():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechTeam value)?  $default,){
final _that = this;
switch (_that) {
case _TechTeam() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String mono,  String oficio,  double rating,  int reviews,  String distance,  String priceLabel,  double pinTop,  double pinLeft,  int crew,  int projects,  int laborCost,  int materialsCost,  int mobilityCost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechTeam() when $default != null:
return $default(_that.id,_that.name,_that.mono,_that.oficio,_that.rating,_that.reviews,_that.distance,_that.priceLabel,_that.pinTop,_that.pinLeft,_that.crew,_that.projects,_that.laborCost,_that.materialsCost,_that.mobilityCost);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String mono,  String oficio,  double rating,  int reviews,  String distance,  String priceLabel,  double pinTop,  double pinLeft,  int crew,  int projects,  int laborCost,  int materialsCost,  int mobilityCost)  $default,) {final _that = this;
switch (_that) {
case _TechTeam():
return $default(_that.id,_that.name,_that.mono,_that.oficio,_that.rating,_that.reviews,_that.distance,_that.priceLabel,_that.pinTop,_that.pinLeft,_that.crew,_that.projects,_that.laborCost,_that.materialsCost,_that.mobilityCost);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String mono,  String oficio,  double rating,  int reviews,  String distance,  String priceLabel,  double pinTop,  double pinLeft,  int crew,  int projects,  int laborCost,  int materialsCost,  int mobilityCost)?  $default,) {final _that = this;
switch (_that) {
case _TechTeam() when $default != null:
return $default(_that.id,_that.name,_that.mono,_that.oficio,_that.rating,_that.reviews,_that.distance,_that.priceLabel,_that.pinTop,_that.pinLeft,_that.crew,_that.projects,_that.laborCost,_that.materialsCost,_that.mobilityCost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TechTeam implements TechTeam {
  const _TechTeam({required this.id, required this.name, required this.mono, required this.oficio, required this.rating, required this.reviews, required this.distance, required this.priceLabel, required this.pinTop, required this.pinLeft, required this.crew, required this.projects, required this.laborCost, required this.materialsCost, required this.mobilityCost});
  factory _TechTeam.fromJson(Map<String, dynamic> json) => _$TechTeamFromJson(json);

@override final  int id;
@override final  String name;
@override final  String mono;
@override final  String oficio;
@override final  double rating;
@override final  int reviews;
@override final  String distance;
@override final  String priceLabel;
@override final  double pinTop;
@override final  double pinLeft;
@override final  int crew;
@override final  int projects;
@override final  int laborCost;
@override final  int materialsCost;
@override final  int mobilityCost;

/// Create a copy of TechTeam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechTeamCopyWith<_TechTeam> get copyWith => __$TechTeamCopyWithImpl<_TechTeam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechTeamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechTeam&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mono, mono) || other.mono == mono)&&(identical(other.oficio, oficio) || other.oficio == oficio)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviews, reviews) || other.reviews == reviews)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&(identical(other.pinTop, pinTop) || other.pinTop == pinTop)&&(identical(other.pinLeft, pinLeft) || other.pinLeft == pinLeft)&&(identical(other.crew, crew) || other.crew == crew)&&(identical(other.projects, projects) || other.projects == projects)&&(identical(other.laborCost, laborCost) || other.laborCost == laborCost)&&(identical(other.materialsCost, materialsCost) || other.materialsCost == materialsCost)&&(identical(other.mobilityCost, mobilityCost) || other.mobilityCost == mobilityCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mono,oficio,rating,reviews,distance,priceLabel,pinTop,pinLeft,crew,projects,laborCost,materialsCost,mobilityCost);

@override
String toString() {
  return 'TechTeam(id: $id, name: $name, mono: $mono, oficio: $oficio, rating: $rating, reviews: $reviews, distance: $distance, priceLabel: $priceLabel, pinTop: $pinTop, pinLeft: $pinLeft, crew: $crew, projects: $projects, laborCost: $laborCost, materialsCost: $materialsCost, mobilityCost: $mobilityCost)';
}


}

/// @nodoc
abstract mixin class _$TechTeamCopyWith<$Res> implements $TechTeamCopyWith<$Res> {
  factory _$TechTeamCopyWith(_TechTeam value, $Res Function(_TechTeam) _then) = __$TechTeamCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String mono, String oficio, double rating, int reviews, String distance, String priceLabel, double pinTop, double pinLeft, int crew, int projects, int laborCost, int materialsCost, int mobilityCost
});




}
/// @nodoc
class __$TechTeamCopyWithImpl<$Res>
    implements _$TechTeamCopyWith<$Res> {
  __$TechTeamCopyWithImpl(this._self, this._then);

  final _TechTeam _self;
  final $Res Function(_TechTeam) _then;

/// Create a copy of TechTeam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? mono = null,Object? oficio = null,Object? rating = null,Object? reviews = null,Object? distance = null,Object? priceLabel = null,Object? pinTop = null,Object? pinLeft = null,Object? crew = null,Object? projects = null,Object? laborCost = null,Object? materialsCost = null,Object? mobilityCost = null,}) {
  return _then(_TechTeam(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mono: null == mono ? _self.mono : mono // ignore: cast_nullable_to_non_nullable
as String,oficio: null == oficio ? _self.oficio : oficio // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as int,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as String,priceLabel: null == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String,pinTop: null == pinTop ? _self.pinTop : pinTop // ignore: cast_nullable_to_non_nullable
as double,pinLeft: null == pinLeft ? _self.pinLeft : pinLeft // ignore: cast_nullable_to_non_nullable
as double,crew: null == crew ? _self.crew : crew // ignore: cast_nullable_to_non_nullable
as int,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as int,laborCost: null == laborCost ? _self.laborCost : laborCost // ignore: cast_nullable_to_non_nullable
as int,materialsCost: null == materialsCost ? _self.materialsCost : materialsCost // ignore: cast_nullable_to_non_nullable
as int,mobilityCost: null == mobilityCost ? _self.mobilityCost : mobilityCost // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
