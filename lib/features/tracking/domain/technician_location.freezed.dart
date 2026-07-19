// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'technician_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TechnicianLocation {

 String get jobRequestId; double get latitude; double get longitude; String get updatedAt;
/// Create a copy of TechnicianLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianLocationCopyWith<TechnicianLocation> get copyWith => _$TechnicianLocationCopyWithImpl<TechnicianLocation>(this as TechnicianLocation, _$identity);

  /// Serializes this TechnicianLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianLocation&&(identical(other.jobRequestId, jobRequestId) || other.jobRequestId == jobRequestId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobRequestId,latitude,longitude,updatedAt);

@override
String toString() {
  return 'TechnicianLocation(jobRequestId: $jobRequestId, latitude: $latitude, longitude: $longitude, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TechnicianLocationCopyWith<$Res>  {
  factory $TechnicianLocationCopyWith(TechnicianLocation value, $Res Function(TechnicianLocation) _then) = _$TechnicianLocationCopyWithImpl;
@useResult
$Res call({
 String jobRequestId, double latitude, double longitude, String updatedAt
});




}
/// @nodoc
class _$TechnicianLocationCopyWithImpl<$Res>
    implements $TechnicianLocationCopyWith<$Res> {
  _$TechnicianLocationCopyWithImpl(this._self, this._then);

  final TechnicianLocation _self;
  final $Res Function(TechnicianLocation) _then;

/// Create a copy of TechnicianLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobRequestId = null,Object? latitude = null,Object? longitude = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
jobRequestId: null == jobRequestId ? _self.jobRequestId : jobRequestId // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianLocation].
extension TechnicianLocationPatterns on TechnicianLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianLocation value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianLocation value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String jobRequestId,  double latitude,  double longitude,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianLocation() when $default != null:
return $default(_that.jobRequestId,_that.latitude,_that.longitude,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String jobRequestId,  double latitude,  double longitude,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TechnicianLocation():
return $default(_that.jobRequestId,_that.latitude,_that.longitude,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String jobRequestId,  double latitude,  double longitude,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianLocation() when $default != null:
return $default(_that.jobRequestId,_that.latitude,_that.longitude,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TechnicianLocation implements TechnicianLocation {
  const _TechnicianLocation({required this.jobRequestId, required this.latitude, required this.longitude, required this.updatedAt});
  factory _TechnicianLocation.fromJson(Map<String, dynamic> json) => _$TechnicianLocationFromJson(json);

@override final  String jobRequestId;
@override final  double latitude;
@override final  double longitude;
@override final  String updatedAt;

/// Create a copy of TechnicianLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianLocationCopyWith<_TechnicianLocation> get copyWith => __$TechnicianLocationCopyWithImpl<_TechnicianLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianLocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianLocation&&(identical(other.jobRequestId, jobRequestId) || other.jobRequestId == jobRequestId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobRequestId,latitude,longitude,updatedAt);

@override
String toString() {
  return 'TechnicianLocation(jobRequestId: $jobRequestId, latitude: $latitude, longitude: $longitude, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TechnicianLocationCopyWith<$Res> implements $TechnicianLocationCopyWith<$Res> {
  factory _$TechnicianLocationCopyWith(_TechnicianLocation value, $Res Function(_TechnicianLocation) _then) = __$TechnicianLocationCopyWithImpl;
@override @useResult
$Res call({
 String jobRequestId, double latitude, double longitude, String updatedAt
});




}
/// @nodoc
class __$TechnicianLocationCopyWithImpl<$Res>
    implements _$TechnicianLocationCopyWith<$Res> {
  __$TechnicianLocationCopyWithImpl(this._self, this._then);

  final _TechnicianLocation _self;
  final $Res Function(_TechnicianLocation) _then;

/// Create a copy of TechnicianLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobRequestId = null,Object? latitude = null,Object? longitude = null,Object? updatedAt = null,}) {
  return _then(_TechnicianLocation(
jobRequestId: null == jobRequestId ? _self.jobRequestId : jobRequestId // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
