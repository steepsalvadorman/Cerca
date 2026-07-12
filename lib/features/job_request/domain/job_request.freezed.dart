// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobRequest {

 String get id; String get clientId; int? get technicianProfileId; int? get techTeamId; String get jobKind; String get status; int get timelineStep; String get feeType; bool get feePaid; String? get paymentMethod; bool get paymentDone; int? get rating; String? get title; String? get address; String? get comment;
/// Create a copy of JobRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobRequestCopyWith<JobRequest> get copyWith => _$JobRequestCopyWithImpl<JobRequest>(this as JobRequest, _$identity);

  /// Serializes this JobRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.technicianProfileId, technicianProfileId) || other.technicianProfileId == technicianProfileId)&&(identical(other.techTeamId, techTeamId) || other.techTeamId == techTeamId)&&(identical(other.jobKind, jobKind) || other.jobKind == jobKind)&&(identical(other.status, status) || other.status == status)&&(identical(other.timelineStep, timelineStep) || other.timelineStep == timelineStep)&&(identical(other.feeType, feeType) || other.feeType == feeType)&&(identical(other.feePaid, feePaid) || other.feePaid == feePaid)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentDone, paymentDone) || other.paymentDone == paymentDone)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.title, title) || other.title == title)&&(identical(other.address, address) || other.address == address)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,technicianProfileId,techTeamId,jobKind,status,timelineStep,feeType,feePaid,paymentMethod,paymentDone,rating,title,address,comment);

@override
String toString() {
  return 'JobRequest(id: $id, clientId: $clientId, technicianProfileId: $technicianProfileId, techTeamId: $techTeamId, jobKind: $jobKind, status: $status, timelineStep: $timelineStep, feeType: $feeType, feePaid: $feePaid, paymentMethod: $paymentMethod, paymentDone: $paymentDone, rating: $rating, title: $title, address: $address, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $JobRequestCopyWith<$Res>  {
  factory $JobRequestCopyWith(JobRequest value, $Res Function(JobRequest) _then) = _$JobRequestCopyWithImpl;
@useResult
$Res call({
 String id, String clientId, int? technicianProfileId, int? techTeamId, String jobKind, String status, int timelineStep, String feeType, bool feePaid, String? paymentMethod, bool paymentDone, int? rating, String? title, String? address, String? comment
});




}
/// @nodoc
class _$JobRequestCopyWithImpl<$Res>
    implements $JobRequestCopyWith<$Res> {
  _$JobRequestCopyWithImpl(this._self, this._then);

  final JobRequest _self;
  final $Res Function(JobRequest) _then;

/// Create a copy of JobRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientId = null,Object? technicianProfileId = freezed,Object? techTeamId = freezed,Object? jobKind = null,Object? status = null,Object? timelineStep = null,Object? feeType = null,Object? feePaid = null,Object? paymentMethod = freezed,Object? paymentDone = null,Object? rating = freezed,Object? title = freezed,Object? address = freezed,Object? comment = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,technicianProfileId: freezed == technicianProfileId ? _self.technicianProfileId : technicianProfileId // ignore: cast_nullable_to_non_nullable
as int?,techTeamId: freezed == techTeamId ? _self.techTeamId : techTeamId // ignore: cast_nullable_to_non_nullable
as int?,jobKind: null == jobKind ? _self.jobKind : jobKind // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,timelineStep: null == timelineStep ? _self.timelineStep : timelineStep // ignore: cast_nullable_to_non_nullable
as int,feeType: null == feeType ? _self.feeType : feeType // ignore: cast_nullable_to_non_nullable
as String,feePaid: null == feePaid ? _self.feePaid : feePaid // ignore: cast_nullable_to_non_nullable
as bool,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentDone: null == paymentDone ? _self.paymentDone : paymentDone // ignore: cast_nullable_to_non_nullable
as bool,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobRequest].
extension JobRequestPatterns on JobRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobRequest value)  $default,){
final _that = this;
switch (_that) {
case _JobRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobRequest value)?  $default,){
final _that = this;
switch (_that) {
case _JobRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String clientId,  int? technicianProfileId,  int? techTeamId,  String jobKind,  String status,  int timelineStep,  String feeType,  bool feePaid,  String? paymentMethod,  bool paymentDone,  int? rating,  String? title,  String? address,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobRequest() when $default != null:
return $default(_that.id,_that.clientId,_that.technicianProfileId,_that.techTeamId,_that.jobKind,_that.status,_that.timelineStep,_that.feeType,_that.feePaid,_that.paymentMethod,_that.paymentDone,_that.rating,_that.title,_that.address,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String clientId,  int? technicianProfileId,  int? techTeamId,  String jobKind,  String status,  int timelineStep,  String feeType,  bool feePaid,  String? paymentMethod,  bool paymentDone,  int? rating,  String? title,  String? address,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _JobRequest():
return $default(_that.id,_that.clientId,_that.technicianProfileId,_that.techTeamId,_that.jobKind,_that.status,_that.timelineStep,_that.feeType,_that.feePaid,_that.paymentMethod,_that.paymentDone,_that.rating,_that.title,_that.address,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String clientId,  int? technicianProfileId,  int? techTeamId,  String jobKind,  String status,  int timelineStep,  String feeType,  bool feePaid,  String? paymentMethod,  bool paymentDone,  int? rating,  String? title,  String? address,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _JobRequest() when $default != null:
return $default(_that.id,_that.clientId,_that.technicianProfileId,_that.techTeamId,_that.jobKind,_that.status,_that.timelineStep,_that.feeType,_that.feePaid,_that.paymentMethod,_that.paymentDone,_that.rating,_that.title,_that.address,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobRequest implements JobRequest {
  const _JobRequest({required this.id, required this.clientId, this.technicianProfileId, this.techTeamId, required this.jobKind, required this.status, required this.timelineStep, required this.feeType, required this.feePaid, this.paymentMethod, required this.paymentDone, this.rating, this.title, this.address, this.comment});
  factory _JobRequest.fromJson(Map<String, dynamic> json) => _$JobRequestFromJson(json);

@override final  String id;
@override final  String clientId;
@override final  int? technicianProfileId;
@override final  int? techTeamId;
@override final  String jobKind;
@override final  String status;
@override final  int timelineStep;
@override final  String feeType;
@override final  bool feePaid;
@override final  String? paymentMethod;
@override final  bool paymentDone;
@override final  int? rating;
@override final  String? title;
@override final  String? address;
@override final  String? comment;

/// Create a copy of JobRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobRequestCopyWith<_JobRequest> get copyWith => __$JobRequestCopyWithImpl<_JobRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.technicianProfileId, technicianProfileId) || other.technicianProfileId == technicianProfileId)&&(identical(other.techTeamId, techTeamId) || other.techTeamId == techTeamId)&&(identical(other.jobKind, jobKind) || other.jobKind == jobKind)&&(identical(other.status, status) || other.status == status)&&(identical(other.timelineStep, timelineStep) || other.timelineStep == timelineStep)&&(identical(other.feeType, feeType) || other.feeType == feeType)&&(identical(other.feePaid, feePaid) || other.feePaid == feePaid)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentDone, paymentDone) || other.paymentDone == paymentDone)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.title, title) || other.title == title)&&(identical(other.address, address) || other.address == address)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,technicianProfileId,techTeamId,jobKind,status,timelineStep,feeType,feePaid,paymentMethod,paymentDone,rating,title,address,comment);

@override
String toString() {
  return 'JobRequest(id: $id, clientId: $clientId, technicianProfileId: $technicianProfileId, techTeamId: $techTeamId, jobKind: $jobKind, status: $status, timelineStep: $timelineStep, feeType: $feeType, feePaid: $feePaid, paymentMethod: $paymentMethod, paymentDone: $paymentDone, rating: $rating, title: $title, address: $address, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$JobRequestCopyWith<$Res> implements $JobRequestCopyWith<$Res> {
  factory _$JobRequestCopyWith(_JobRequest value, $Res Function(_JobRequest) _then) = __$JobRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String clientId, int? technicianProfileId, int? techTeamId, String jobKind, String status, int timelineStep, String feeType, bool feePaid, String? paymentMethod, bool paymentDone, int? rating, String? title, String? address, String? comment
});




}
/// @nodoc
class __$JobRequestCopyWithImpl<$Res>
    implements _$JobRequestCopyWith<$Res> {
  __$JobRequestCopyWithImpl(this._self, this._then);

  final _JobRequest _self;
  final $Res Function(_JobRequest) _then;

/// Create a copy of JobRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientId = null,Object? technicianProfileId = freezed,Object? techTeamId = freezed,Object? jobKind = null,Object? status = null,Object? timelineStep = null,Object? feeType = null,Object? feePaid = null,Object? paymentMethod = freezed,Object? paymentDone = null,Object? rating = freezed,Object? title = freezed,Object? address = freezed,Object? comment = freezed,}) {
  return _then(_JobRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,technicianProfileId: freezed == technicianProfileId ? _self.technicianProfileId : technicianProfileId // ignore: cast_nullable_to_non_nullable
as int?,techTeamId: freezed == techTeamId ? _self.techTeamId : techTeamId // ignore: cast_nullable_to_non_nullable
as int?,jobKind: null == jobKind ? _self.jobKind : jobKind // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,timelineStep: null == timelineStep ? _self.timelineStep : timelineStep // ignore: cast_nullable_to_non_nullable
as int,feeType: null == feeType ? _self.feeType : feeType // ignore: cast_nullable_to_non_nullable
as String,feePaid: null == feePaid ? _self.feePaid : feePaid // ignore: cast_nullable_to_non_nullable
as bool,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentDone: null == paymentDone ? _self.paymentDone : paymentDone // ignore: cast_nullable_to_non_nullable
as bool,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
