// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spaced_repetition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SrsMemory {

 double get stability; double get difficulty; DateTime get lastReviewAt;
/// Create a copy of SrsMemory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SrsMemoryCopyWith<SrsMemory> get copyWith => _$SrsMemoryCopyWithImpl<SrsMemory>(this as SrsMemory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SrsMemory&&(identical(other.stability, stability) || other.stability == stability)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.lastReviewAt, lastReviewAt) || other.lastReviewAt == lastReviewAt));
}


@override
int get hashCode => Object.hash(runtimeType,stability,difficulty,lastReviewAt);

@override
String toString() {
  return 'SrsMemory(stability: $stability, difficulty: $difficulty, lastReviewAt: $lastReviewAt)';
}


}

/// @nodoc
abstract mixin class $SrsMemoryCopyWith<$Res>  {
  factory $SrsMemoryCopyWith(SrsMemory value, $Res Function(SrsMemory) _then) = _$SrsMemoryCopyWithImpl;
@useResult
$Res call({
 double stability, double difficulty, DateTime lastReviewAt
});




}
/// @nodoc
class _$SrsMemoryCopyWithImpl<$Res>
    implements $SrsMemoryCopyWith<$Res> {
  _$SrsMemoryCopyWithImpl(this._self, this._then);

  final SrsMemory _self;
  final $Res Function(SrsMemory) _then;

/// Create a copy of SrsMemory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stability = null,Object? difficulty = null,Object? lastReviewAt = null,}) {
  return _then(_self.copyWith(
stability: null == stability ? _self.stability : stability // ignore: cast_nullable_to_non_nullable
as double,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as double,lastReviewAt: null == lastReviewAt ? _self.lastReviewAt : lastReviewAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SrsMemory].
extension SrsMemoryPatterns on SrsMemory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SrsMemory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SrsMemory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SrsMemory value)  $default,){
final _that = this;
switch (_that) {
case _SrsMemory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SrsMemory value)?  $default,){
final _that = this;
switch (_that) {
case _SrsMemory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double stability,  double difficulty,  DateTime lastReviewAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SrsMemory() when $default != null:
return $default(_that.stability,_that.difficulty,_that.lastReviewAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double stability,  double difficulty,  DateTime lastReviewAt)  $default,) {final _that = this;
switch (_that) {
case _SrsMemory():
return $default(_that.stability,_that.difficulty,_that.lastReviewAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double stability,  double difficulty,  DateTime lastReviewAt)?  $default,) {final _that = this;
switch (_that) {
case _SrsMemory() when $default != null:
return $default(_that.stability,_that.difficulty,_that.lastReviewAt);case _:
  return null;

}
}

}

/// @nodoc


class _SrsMemory implements SrsMemory {
  const _SrsMemory({required this.stability, required this.difficulty, required this.lastReviewAt});
  

@override final  double stability;
@override final  double difficulty;
@override final  DateTime lastReviewAt;

/// Create a copy of SrsMemory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SrsMemoryCopyWith<_SrsMemory> get copyWith => __$SrsMemoryCopyWithImpl<_SrsMemory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SrsMemory&&(identical(other.stability, stability) || other.stability == stability)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.lastReviewAt, lastReviewAt) || other.lastReviewAt == lastReviewAt));
}


@override
int get hashCode => Object.hash(runtimeType,stability,difficulty,lastReviewAt);

@override
String toString() {
  return 'SrsMemory(stability: $stability, difficulty: $difficulty, lastReviewAt: $lastReviewAt)';
}


}

/// @nodoc
abstract mixin class _$SrsMemoryCopyWith<$Res> implements $SrsMemoryCopyWith<$Res> {
  factory _$SrsMemoryCopyWith(_SrsMemory value, $Res Function(_SrsMemory) _then) = __$SrsMemoryCopyWithImpl;
@override @useResult
$Res call({
 double stability, double difficulty, DateTime lastReviewAt
});




}
/// @nodoc
class __$SrsMemoryCopyWithImpl<$Res>
    implements _$SrsMemoryCopyWith<$Res> {
  __$SrsMemoryCopyWithImpl(this._self, this._then);

  final _SrsMemory _self;
  final $Res Function(_SrsMemory) _then;

/// Create a copy of SrsMemory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stability = null,Object? difficulty = null,Object? lastReviewAt = null,}) {
  return _then(_SrsMemory(
stability: null == stability ? _self.stability : stability // ignore: cast_nullable_to_non_nullable
as double,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as double,lastReviewAt: null == lastReviewAt ? _self.lastReviewAt : lastReviewAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$SrsResult {

 double get stability; double get difficulty; DateTime get dueAt;
/// Create a copy of SrsResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SrsResultCopyWith<SrsResult> get copyWith => _$SrsResultCopyWithImpl<SrsResult>(this as SrsResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SrsResult&&(identical(other.stability, stability) || other.stability == stability)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt));
}


@override
int get hashCode => Object.hash(runtimeType,stability,difficulty,dueAt);

@override
String toString() {
  return 'SrsResult(stability: $stability, difficulty: $difficulty, dueAt: $dueAt)';
}


}

/// @nodoc
abstract mixin class $SrsResultCopyWith<$Res>  {
  factory $SrsResultCopyWith(SrsResult value, $Res Function(SrsResult) _then) = _$SrsResultCopyWithImpl;
@useResult
$Res call({
 double stability, double difficulty, DateTime dueAt
});




}
/// @nodoc
class _$SrsResultCopyWithImpl<$Res>
    implements $SrsResultCopyWith<$Res> {
  _$SrsResultCopyWithImpl(this._self, this._then);

  final SrsResult _self;
  final $Res Function(SrsResult) _then;

/// Create a copy of SrsResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stability = null,Object? difficulty = null,Object? dueAt = null,}) {
  return _then(_self.copyWith(
stability: null == stability ? _self.stability : stability // ignore: cast_nullable_to_non_nullable
as double,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as double,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SrsResult].
extension SrsResultPatterns on SrsResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SrsResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SrsResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SrsResult value)  $default,){
final _that = this;
switch (_that) {
case _SrsResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SrsResult value)?  $default,){
final _that = this;
switch (_that) {
case _SrsResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double stability,  double difficulty,  DateTime dueAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SrsResult() when $default != null:
return $default(_that.stability,_that.difficulty,_that.dueAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double stability,  double difficulty,  DateTime dueAt)  $default,) {final _that = this;
switch (_that) {
case _SrsResult():
return $default(_that.stability,_that.difficulty,_that.dueAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double stability,  double difficulty,  DateTime dueAt)?  $default,) {final _that = this;
switch (_that) {
case _SrsResult() when $default != null:
return $default(_that.stability,_that.difficulty,_that.dueAt);case _:
  return null;

}
}

}

/// @nodoc


class _SrsResult implements SrsResult {
  const _SrsResult({required this.stability, required this.difficulty, required this.dueAt});
  

@override final  double stability;
@override final  double difficulty;
@override final  DateTime dueAt;

/// Create a copy of SrsResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SrsResultCopyWith<_SrsResult> get copyWith => __$SrsResultCopyWithImpl<_SrsResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SrsResult&&(identical(other.stability, stability) || other.stability == stability)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt));
}


@override
int get hashCode => Object.hash(runtimeType,stability,difficulty,dueAt);

@override
String toString() {
  return 'SrsResult(stability: $stability, difficulty: $difficulty, dueAt: $dueAt)';
}


}

/// @nodoc
abstract mixin class _$SrsResultCopyWith<$Res> implements $SrsResultCopyWith<$Res> {
  factory _$SrsResultCopyWith(_SrsResult value, $Res Function(_SrsResult) _then) = __$SrsResultCopyWithImpl;
@override @useResult
$Res call({
 double stability, double difficulty, DateTime dueAt
});




}
/// @nodoc
class __$SrsResultCopyWithImpl<$Res>
    implements _$SrsResultCopyWith<$Res> {
  __$SrsResultCopyWithImpl(this._self, this._then);

  final _SrsResult _self;
  final $Res Function(_SrsResult) _then;

/// Create a copy of SrsResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stability = null,Object? difficulty = null,Object? dueAt = null,}) {
  return _then(_SrsResult(
stability: null == stability ? _self.stability : stability // ignore: cast_nullable_to_non_nullable
as double,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as double,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
