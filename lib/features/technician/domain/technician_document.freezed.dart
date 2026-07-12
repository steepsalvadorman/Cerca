// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'technician_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TechnicianDocumentStatus {

 String get documentKey; String get status;
/// Create a copy of TechnicianDocumentStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianDocumentStatusCopyWith<TechnicianDocumentStatus> get copyWith => _$TechnicianDocumentStatusCopyWithImpl<TechnicianDocumentStatus>(this as TechnicianDocumentStatus, _$identity);

  /// Serializes this TechnicianDocumentStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianDocumentStatus&&(identical(other.documentKey, documentKey) || other.documentKey == documentKey)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentKey,status);

@override
String toString() {
  return 'TechnicianDocumentStatus(documentKey: $documentKey, status: $status)';
}


}

/// @nodoc
abstract mixin class $TechnicianDocumentStatusCopyWith<$Res>  {
  factory $TechnicianDocumentStatusCopyWith(TechnicianDocumentStatus value, $Res Function(TechnicianDocumentStatus) _then) = _$TechnicianDocumentStatusCopyWithImpl;
@useResult
$Res call({
 String documentKey, String status
});




}
/// @nodoc
class _$TechnicianDocumentStatusCopyWithImpl<$Res>
    implements $TechnicianDocumentStatusCopyWith<$Res> {
  _$TechnicianDocumentStatusCopyWithImpl(this._self, this._then);

  final TechnicianDocumentStatus _self;
  final $Res Function(TechnicianDocumentStatus) _then;

/// Create a copy of TechnicianDocumentStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentKey = null,Object? status = null,}) {
  return _then(_self.copyWith(
documentKey: null == documentKey ? _self.documentKey : documentKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianDocumentStatus].
extension TechnicianDocumentStatusPatterns on TechnicianDocumentStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianDocumentStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianDocumentStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianDocumentStatus value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianDocumentStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianDocumentStatus value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianDocumentStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String documentKey,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianDocumentStatus() when $default != null:
return $default(_that.documentKey,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String documentKey,  String status)  $default,) {final _that = this;
switch (_that) {
case _TechnicianDocumentStatus():
return $default(_that.documentKey,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String documentKey,  String status)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianDocumentStatus() when $default != null:
return $default(_that.documentKey,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TechnicianDocumentStatus implements TechnicianDocumentStatus {
  const _TechnicianDocumentStatus({required this.documentKey, required this.status});
  factory _TechnicianDocumentStatus.fromJson(Map<String, dynamic> json) => _$TechnicianDocumentStatusFromJson(json);

@override final  String documentKey;
@override final  String status;

/// Create a copy of TechnicianDocumentStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianDocumentStatusCopyWith<_TechnicianDocumentStatus> get copyWith => __$TechnicianDocumentStatusCopyWithImpl<_TechnicianDocumentStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianDocumentStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianDocumentStatus&&(identical(other.documentKey, documentKey) || other.documentKey == documentKey)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentKey,status);

@override
String toString() {
  return 'TechnicianDocumentStatus(documentKey: $documentKey, status: $status)';
}


}

/// @nodoc
abstract mixin class _$TechnicianDocumentStatusCopyWith<$Res> implements $TechnicianDocumentStatusCopyWith<$Res> {
  factory _$TechnicianDocumentStatusCopyWith(_TechnicianDocumentStatus value, $Res Function(_TechnicianDocumentStatus) _then) = __$TechnicianDocumentStatusCopyWithImpl;
@override @useResult
$Res call({
 String documentKey, String status
});




}
/// @nodoc
class __$TechnicianDocumentStatusCopyWithImpl<$Res>
    implements _$TechnicianDocumentStatusCopyWith<$Res> {
  __$TechnicianDocumentStatusCopyWithImpl(this._self, this._then);

  final _TechnicianDocumentStatus _self;
  final $Res Function(_TechnicianDocumentStatus) _then;

/// Create a copy of TechnicianDocumentStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentKey = null,Object? status = null,}) {
  return _then(_TechnicianDocumentStatus(
documentKey: null == documentKey ? _self.documentKey : documentKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
