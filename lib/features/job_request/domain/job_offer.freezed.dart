// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobOffer {

 int get id; String get jobRequestId; int get technicianProfileId; int get price; String get eta; String get name; String get mono; String get oficio; double get rating; bool get verified;
/// Create a copy of JobOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobOfferCopyWith<JobOffer> get copyWith => _$JobOfferCopyWithImpl<JobOffer>(this as JobOffer, _$identity);

  /// Serializes this JobOffer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobOffer&&(identical(other.id, id) || other.id == id)&&(identical(other.jobRequestId, jobRequestId) || other.jobRequestId == jobRequestId)&&(identical(other.technicianProfileId, technicianProfileId) || other.technicianProfileId == technicianProfileId)&&(identical(other.price, price) || other.price == price)&&(identical(other.eta, eta) || other.eta == eta)&&(identical(other.name, name) || other.name == name)&&(identical(other.mono, mono) || other.mono == mono)&&(identical(other.oficio, oficio) || other.oficio == oficio)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.verified, verified) || other.verified == verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobRequestId,technicianProfileId,price,eta,name,mono,oficio,rating,verified);

@override
String toString() {
  return 'JobOffer(id: $id, jobRequestId: $jobRequestId, technicianProfileId: $technicianProfileId, price: $price, eta: $eta, name: $name, mono: $mono, oficio: $oficio, rating: $rating, verified: $verified)';
}


}

/// @nodoc
abstract mixin class $JobOfferCopyWith<$Res>  {
  factory $JobOfferCopyWith(JobOffer value, $Res Function(JobOffer) _then) = _$JobOfferCopyWithImpl;
@useResult
$Res call({
 int id, String jobRequestId, int technicianProfileId, int price, String eta, String name, String mono, String oficio, double rating, bool verified
});




}
/// @nodoc
class _$JobOfferCopyWithImpl<$Res>
    implements $JobOfferCopyWith<$Res> {
  _$JobOfferCopyWithImpl(this._self, this._then);

  final JobOffer _self;
  final $Res Function(JobOffer) _then;

/// Create a copy of JobOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? jobRequestId = null,Object? technicianProfileId = null,Object? price = null,Object? eta = null,Object? name = null,Object? mono = null,Object? oficio = null,Object? rating = null,Object? verified = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,jobRequestId: null == jobRequestId ? _self.jobRequestId : jobRequestId // ignore: cast_nullable_to_non_nullable
as String,technicianProfileId: null == technicianProfileId ? _self.technicianProfileId : technicianProfileId // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,eta: null == eta ? _self.eta : eta // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mono: null == mono ? _self.mono : mono // ignore: cast_nullable_to_non_nullable
as String,oficio: null == oficio ? _self.oficio : oficio // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [JobOffer].
extension JobOfferPatterns on JobOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobOffer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobOffer value)  $default,){
final _that = this;
switch (_that) {
case _JobOffer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobOffer value)?  $default,){
final _that = this;
switch (_that) {
case _JobOffer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String jobRequestId,  int technicianProfileId,  int price,  String eta,  String name,  String mono,  String oficio,  double rating,  bool verified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobOffer() when $default != null:
return $default(_that.id,_that.jobRequestId,_that.technicianProfileId,_that.price,_that.eta,_that.name,_that.mono,_that.oficio,_that.rating,_that.verified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String jobRequestId,  int technicianProfileId,  int price,  String eta,  String name,  String mono,  String oficio,  double rating,  bool verified)  $default,) {final _that = this;
switch (_that) {
case _JobOffer():
return $default(_that.id,_that.jobRequestId,_that.technicianProfileId,_that.price,_that.eta,_that.name,_that.mono,_that.oficio,_that.rating,_that.verified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String jobRequestId,  int technicianProfileId,  int price,  String eta,  String name,  String mono,  String oficio,  double rating,  bool verified)?  $default,) {final _that = this;
switch (_that) {
case _JobOffer() when $default != null:
return $default(_that.id,_that.jobRequestId,_that.technicianProfileId,_that.price,_that.eta,_that.name,_that.mono,_that.oficio,_that.rating,_that.verified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobOffer implements JobOffer {
  const _JobOffer({required this.id, required this.jobRequestId, required this.technicianProfileId, required this.price, required this.eta, required this.name, required this.mono, required this.oficio, required this.rating, required this.verified});
  factory _JobOffer.fromJson(Map<String, dynamic> json) => _$JobOfferFromJson(json);

@override final  int id;
@override final  String jobRequestId;
@override final  int technicianProfileId;
@override final  int price;
@override final  String eta;
@override final  String name;
@override final  String mono;
@override final  String oficio;
@override final  double rating;
@override final  bool verified;

/// Create a copy of JobOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobOfferCopyWith<_JobOffer> get copyWith => __$JobOfferCopyWithImpl<_JobOffer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobOfferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobOffer&&(identical(other.id, id) || other.id == id)&&(identical(other.jobRequestId, jobRequestId) || other.jobRequestId == jobRequestId)&&(identical(other.technicianProfileId, technicianProfileId) || other.technicianProfileId == technicianProfileId)&&(identical(other.price, price) || other.price == price)&&(identical(other.eta, eta) || other.eta == eta)&&(identical(other.name, name) || other.name == name)&&(identical(other.mono, mono) || other.mono == mono)&&(identical(other.oficio, oficio) || other.oficio == oficio)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.verified, verified) || other.verified == verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobRequestId,technicianProfileId,price,eta,name,mono,oficio,rating,verified);

@override
String toString() {
  return 'JobOffer(id: $id, jobRequestId: $jobRequestId, technicianProfileId: $technicianProfileId, price: $price, eta: $eta, name: $name, mono: $mono, oficio: $oficio, rating: $rating, verified: $verified)';
}


}

/// @nodoc
abstract mixin class _$JobOfferCopyWith<$Res> implements $JobOfferCopyWith<$Res> {
  factory _$JobOfferCopyWith(_JobOffer value, $Res Function(_JobOffer) _then) = __$JobOfferCopyWithImpl;
@override @useResult
$Res call({
 int id, String jobRequestId, int technicianProfileId, int price, String eta, String name, String mono, String oficio, double rating, bool verified
});




}
/// @nodoc
class __$JobOfferCopyWithImpl<$Res>
    implements _$JobOfferCopyWith<$Res> {
  __$JobOfferCopyWithImpl(this._self, this._then);

  final _JobOffer _self;
  final $Res Function(_JobOffer) _then;

/// Create a copy of JobOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? jobRequestId = null,Object? technicianProfileId = null,Object? price = null,Object? eta = null,Object? name = null,Object? mono = null,Object? oficio = null,Object? rating = null,Object? verified = null,}) {
  return _then(_JobOffer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,jobRequestId: null == jobRequestId ? _self.jobRequestId : jobRequestId // ignore: cast_nullable_to_non_nullable
as String,technicianProfileId: null == technicianProfileId ? _self.technicianProfileId : technicianProfileId // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,eta: null == eta ? _self.eta : eta // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mono: null == mono ? _self.mono : mono // ignore: cast_nullable_to_non_nullable
as String,oficio: null == oficio ? _self.oficio : oficio // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
