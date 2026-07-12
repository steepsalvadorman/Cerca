// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_payment_method.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClientPaymentMethod {

 String get id; String get label; String get detail;
/// Create a copy of ClientPaymentMethod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientPaymentMethodCopyWith<ClientPaymentMethod> get copyWith => _$ClientPaymentMethodCopyWithImpl<ClientPaymentMethod>(this as ClientPaymentMethod, _$identity);

  /// Serializes this ClientPaymentMethod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientPaymentMethod&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,detail);

@override
String toString() {
  return 'ClientPaymentMethod(id: $id, label: $label, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $ClientPaymentMethodCopyWith<$Res>  {
  factory $ClientPaymentMethodCopyWith(ClientPaymentMethod value, $Res Function(ClientPaymentMethod) _then) = _$ClientPaymentMethodCopyWithImpl;
@useResult
$Res call({
 String id, String label, String detail
});




}
/// @nodoc
class _$ClientPaymentMethodCopyWithImpl<$Res>
    implements $ClientPaymentMethodCopyWith<$Res> {
  _$ClientPaymentMethodCopyWithImpl(this._self, this._then);

  final ClientPaymentMethod _self;
  final $Res Function(ClientPaymentMethod) _then;

/// Create a copy of ClientPaymentMethod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? detail = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientPaymentMethod].
extension ClientPaymentMethodPatterns on ClientPaymentMethod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientPaymentMethod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientPaymentMethod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientPaymentMethod value)  $default,){
final _that = this;
switch (_that) {
case _ClientPaymentMethod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientPaymentMethod value)?  $default,){
final _that = this;
switch (_that) {
case _ClientPaymentMethod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  String detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientPaymentMethod() when $default != null:
return $default(_that.id,_that.label,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  String detail)  $default,) {final _that = this;
switch (_that) {
case _ClientPaymentMethod():
return $default(_that.id,_that.label,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  String detail)?  $default,) {final _that = this;
switch (_that) {
case _ClientPaymentMethod() when $default != null:
return $default(_that.id,_that.label,_that.detail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientPaymentMethod implements ClientPaymentMethod {
  const _ClientPaymentMethod({required this.id, required this.label, required this.detail});
  factory _ClientPaymentMethod.fromJson(Map<String, dynamic> json) => _$ClientPaymentMethodFromJson(json);

@override final  String id;
@override final  String label;
@override final  String detail;

/// Create a copy of ClientPaymentMethod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientPaymentMethodCopyWith<_ClientPaymentMethod> get copyWith => __$ClientPaymentMethodCopyWithImpl<_ClientPaymentMethod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientPaymentMethodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientPaymentMethod&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,detail);

@override
String toString() {
  return 'ClientPaymentMethod(id: $id, label: $label, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$ClientPaymentMethodCopyWith<$Res> implements $ClientPaymentMethodCopyWith<$Res> {
  factory _$ClientPaymentMethodCopyWith(_ClientPaymentMethod value, $Res Function(_ClientPaymentMethod) _then) = __$ClientPaymentMethodCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, String detail
});




}
/// @nodoc
class __$ClientPaymentMethodCopyWithImpl<$Res>
    implements _$ClientPaymentMethodCopyWith<$Res> {
  __$ClientPaymentMethodCopyWithImpl(this._self, this._then);

  final _ClientPaymentMethod _self;
  final $Res Function(_ClientPaymentMethod) _then;

/// Create a copy of ClientPaymentMethod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? detail = null,}) {
  return _then(_ClientPaymentMethod(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
