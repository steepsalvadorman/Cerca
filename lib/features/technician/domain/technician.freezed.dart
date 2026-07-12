// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'technician.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Technician {

 int get id; String get name; String get mono; String get oficio; double get rating; int get reviews; String get distance; String get priceLabel; double get pinTop; double get pinLeft; int get coverageKm; List<String> get availableDays; List<String> get categories; bool get isVerified;
/// Create a copy of Technician
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianCopyWith<Technician> get copyWith => _$TechnicianCopyWithImpl<Technician>(this as Technician, _$identity);

  /// Serializes this Technician to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Technician&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mono, mono) || other.mono == mono)&&(identical(other.oficio, oficio) || other.oficio == oficio)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviews, reviews) || other.reviews == reviews)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&(identical(other.pinTop, pinTop) || other.pinTop == pinTop)&&(identical(other.pinLeft, pinLeft) || other.pinLeft == pinLeft)&&(identical(other.coverageKm, coverageKm) || other.coverageKm == coverageKm)&&const DeepCollectionEquality().equals(other.availableDays, availableDays)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mono,oficio,rating,reviews,distance,priceLabel,pinTop,pinLeft,coverageKm,const DeepCollectionEquality().hash(availableDays),const DeepCollectionEquality().hash(categories),isVerified);

@override
String toString() {
  return 'Technician(id: $id, name: $name, mono: $mono, oficio: $oficio, rating: $rating, reviews: $reviews, distance: $distance, priceLabel: $priceLabel, pinTop: $pinTop, pinLeft: $pinLeft, coverageKm: $coverageKm, availableDays: $availableDays, categories: $categories, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class $TechnicianCopyWith<$Res>  {
  factory $TechnicianCopyWith(Technician value, $Res Function(Technician) _then) = _$TechnicianCopyWithImpl;
@useResult
$Res call({
 int id, String name, String mono, String oficio, double rating, int reviews, String distance, String priceLabel, double pinTop, double pinLeft, int coverageKm, List<String> availableDays, List<String> categories, bool isVerified
});




}
/// @nodoc
class _$TechnicianCopyWithImpl<$Res>
    implements $TechnicianCopyWith<$Res> {
  _$TechnicianCopyWithImpl(this._self, this._then);

  final Technician _self;
  final $Res Function(Technician) _then;

/// Create a copy of Technician
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? mono = null,Object? oficio = null,Object? rating = null,Object? reviews = null,Object? distance = null,Object? priceLabel = null,Object? pinTop = null,Object? pinLeft = null,Object? coverageKm = null,Object? availableDays = null,Object? categories = null,Object? isVerified = null,}) {
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
as double,coverageKm: null == coverageKm ? _self.coverageKm : coverageKm // ignore: cast_nullable_to_non_nullable
as int,availableDays: null == availableDays ? _self.availableDays : availableDays // ignore: cast_nullable_to_non_nullable
as List<String>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Technician].
extension TechnicianPatterns on Technician {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Technician value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Technician() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Technician value)  $default,){
final _that = this;
switch (_that) {
case _Technician():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Technician value)?  $default,){
final _that = this;
switch (_that) {
case _Technician() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String mono,  String oficio,  double rating,  int reviews,  String distance,  String priceLabel,  double pinTop,  double pinLeft,  int coverageKm,  List<String> availableDays,  List<String> categories,  bool isVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Technician() when $default != null:
return $default(_that.id,_that.name,_that.mono,_that.oficio,_that.rating,_that.reviews,_that.distance,_that.priceLabel,_that.pinTop,_that.pinLeft,_that.coverageKm,_that.availableDays,_that.categories,_that.isVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String mono,  String oficio,  double rating,  int reviews,  String distance,  String priceLabel,  double pinTop,  double pinLeft,  int coverageKm,  List<String> availableDays,  List<String> categories,  bool isVerified)  $default,) {final _that = this;
switch (_that) {
case _Technician():
return $default(_that.id,_that.name,_that.mono,_that.oficio,_that.rating,_that.reviews,_that.distance,_that.priceLabel,_that.pinTop,_that.pinLeft,_that.coverageKm,_that.availableDays,_that.categories,_that.isVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String mono,  String oficio,  double rating,  int reviews,  String distance,  String priceLabel,  double pinTop,  double pinLeft,  int coverageKm,  List<String> availableDays,  List<String> categories,  bool isVerified)?  $default,) {final _that = this;
switch (_that) {
case _Technician() when $default != null:
return $default(_that.id,_that.name,_that.mono,_that.oficio,_that.rating,_that.reviews,_that.distance,_that.priceLabel,_that.pinTop,_that.pinLeft,_that.coverageKm,_that.availableDays,_that.categories,_that.isVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Technician implements Technician {
  const _Technician({required this.id, required this.name, required this.mono, required this.oficio, required this.rating, required this.reviews, required this.distance, required this.priceLabel, required this.pinTop, required this.pinLeft, required this.coverageKm, required final  List<String> availableDays, required final  List<String> categories, required this.isVerified}): _availableDays = availableDays,_categories = categories;
  factory _Technician.fromJson(Map<String, dynamic> json) => _$TechnicianFromJson(json);

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
@override final  int coverageKm;
 final  List<String> _availableDays;
@override List<String> get availableDays {
  if (_availableDays is EqualUnmodifiableListView) return _availableDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableDays);
}

 final  List<String> _categories;
@override List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override final  bool isVerified;

/// Create a copy of Technician
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianCopyWith<_Technician> get copyWith => __$TechnicianCopyWithImpl<_Technician>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Technician&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mono, mono) || other.mono == mono)&&(identical(other.oficio, oficio) || other.oficio == oficio)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviews, reviews) || other.reviews == reviews)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&(identical(other.pinTop, pinTop) || other.pinTop == pinTop)&&(identical(other.pinLeft, pinLeft) || other.pinLeft == pinLeft)&&(identical(other.coverageKm, coverageKm) || other.coverageKm == coverageKm)&&const DeepCollectionEquality().equals(other._availableDays, _availableDays)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mono,oficio,rating,reviews,distance,priceLabel,pinTop,pinLeft,coverageKm,const DeepCollectionEquality().hash(_availableDays),const DeepCollectionEquality().hash(_categories),isVerified);

@override
String toString() {
  return 'Technician(id: $id, name: $name, mono: $mono, oficio: $oficio, rating: $rating, reviews: $reviews, distance: $distance, priceLabel: $priceLabel, pinTop: $pinTop, pinLeft: $pinLeft, coverageKm: $coverageKm, availableDays: $availableDays, categories: $categories, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class _$TechnicianCopyWith<$Res> implements $TechnicianCopyWith<$Res> {
  factory _$TechnicianCopyWith(_Technician value, $Res Function(_Technician) _then) = __$TechnicianCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String mono, String oficio, double rating, int reviews, String distance, String priceLabel, double pinTop, double pinLeft, int coverageKm, List<String> availableDays, List<String> categories, bool isVerified
});




}
/// @nodoc
class __$TechnicianCopyWithImpl<$Res>
    implements _$TechnicianCopyWith<$Res> {
  __$TechnicianCopyWithImpl(this._self, this._then);

  final _Technician _self;
  final $Res Function(_Technician) _then;

/// Create a copy of Technician
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? mono = null,Object? oficio = null,Object? rating = null,Object? reviews = null,Object? distance = null,Object? priceLabel = null,Object? pinTop = null,Object? pinLeft = null,Object? coverageKm = null,Object? availableDays = null,Object? categories = null,Object? isVerified = null,}) {
  return _then(_Technician(
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
as double,coverageKm: null == coverageKm ? _self.coverageKm : coverageKm // ignore: cast_nullable_to_non_nullable
as int,availableDays: null == availableDays ? _self._availableDays : availableDays // ignore: cast_nullable_to_non_nullable
as List<String>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
