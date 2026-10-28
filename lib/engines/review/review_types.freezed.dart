// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReviewState {

/// 0 = not started, 1..7 = stored level.
 int get level; double? get stability; double? get difficulty;/// Anchor for decay. Shifted forward by pauses (decision D6).
 DateTime? get lastReviewAt; DateTime? get dueAt; int get reps; int get lapses; DateTime? get pausedAt;
/// Create a copy of ReviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewStateCopyWith<ReviewState> get copyWith => _$ReviewStateCopyWithImpl<ReviewState>(this as ReviewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewState&&(identical(other.level, level) || other.level == level)&&(identical(other.stability, stability) || other.stability == stability)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.lastReviewAt, lastReviewAt) || other.lastReviewAt == lastReviewAt)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.lapses, lapses) || other.lapses == lapses)&&(identical(other.pausedAt, pausedAt) || other.pausedAt == pausedAt));
}


@override
int get hashCode => Object.hash(runtimeType,level,stability,difficulty,lastReviewAt,dueAt,reps,lapses,pausedAt);

@override
String toString() {
  return 'ReviewState(level: $level, stability: $stability, difficulty: $difficulty, lastReviewAt: $lastReviewAt, dueAt: $dueAt, reps: $reps, lapses: $lapses, pausedAt: $pausedAt)';
}


}

/// @nodoc
abstract mixin class $ReviewStateCopyWith<$Res>  {
  factory $ReviewStateCopyWith(ReviewState value, $Res Function(ReviewState) _then) = _$ReviewStateCopyWithImpl;
@useResult
$Res call({
 int level, double? stability, double? difficulty, DateTime? lastReviewAt, DateTime? dueAt, int reps, int lapses, DateTime? pausedAt
});




}
/// @nodoc
class _$ReviewStateCopyWithImpl<$Res>
    implements $ReviewStateCopyWith<$Res> {
  _$ReviewStateCopyWithImpl(this._self, this._then);

  final ReviewState _self;
  final $Res Function(ReviewState) _then;

/// Create a copy of ReviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? stability = freezed,Object? difficulty = freezed,Object? lastReviewAt = freezed,Object? dueAt = freezed,Object? reps = null,Object? lapses = null,Object? pausedAt = freezed,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,stability: freezed == stability ? _self.stability : stability // ignore: cast_nullable_to_non_nullable
as double?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as double?,lastReviewAt: freezed == lastReviewAt ? _self.lastReviewAt : lastReviewAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,lapses: null == lapses ? _self.lapses : lapses // ignore: cast_nullable_to_non_nullable
as int,pausedAt: freezed == pausedAt ? _self.pausedAt : pausedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewState].
extension ReviewStatePatterns on ReviewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewState value)  $default,){
final _that = this;
switch (_that) {
case _ReviewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewState value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int level,  double? stability,  double? difficulty,  DateTime? lastReviewAt,  DateTime? dueAt,  int reps,  int lapses,  DateTime? pausedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewState() when $default != null:
return $default(_that.level,_that.stability,_that.difficulty,_that.lastReviewAt,_that.dueAt,_that.reps,_that.lapses,_that.pausedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int level,  double? stability,  double? difficulty,  DateTime? lastReviewAt,  DateTime? dueAt,  int reps,  int lapses,  DateTime? pausedAt)  $default,) {final _that = this;
switch (_that) {
case _ReviewState():
return $default(_that.level,_that.stability,_that.difficulty,_that.lastReviewAt,_that.dueAt,_that.reps,_that.lapses,_that.pausedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int level,  double? stability,  double? difficulty,  DateTime? lastReviewAt,  DateTime? dueAt,  int reps,  int lapses,  DateTime? pausedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReviewState() when $default != null:
return $default(_that.level,_that.stability,_that.difficulty,_that.lastReviewAt,_that.dueAt,_that.reps,_that.lapses,_that.pausedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewState extends ReviewState {
  const _ReviewState({this.level = 0, this.stability, this.difficulty, this.lastReviewAt, this.dueAt, this.reps = 0, this.lapses = 0, this.pausedAt}): super._();
  

/// 0 = not started, 1..7 = stored level.
@override@JsonKey() final  int level;
@override final  double? stability;
@override final  double? difficulty;
/// Anchor for decay. Shifted forward by pauses (decision D6).
@override final  DateTime? lastReviewAt;
@override final  DateTime? dueAt;
@override@JsonKey() final  int reps;
@override@JsonKey() final  int lapses;
@override final  DateTime? pausedAt;

/// Create a copy of ReviewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewStateCopyWith<_ReviewState> get copyWith => __$ReviewStateCopyWithImpl<_ReviewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewState&&(identical(other.level, level) || other.level == level)&&(identical(other.stability, stability) || other.stability == stability)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.lastReviewAt, lastReviewAt) || other.lastReviewAt == lastReviewAt)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.lapses, lapses) || other.lapses == lapses)&&(identical(other.pausedAt, pausedAt) || other.pausedAt == pausedAt));
}


@override
int get hashCode => Object.hash(runtimeType,level,stability,difficulty,lastReviewAt,dueAt,reps,lapses,pausedAt);

@override
String toString() {
  return 'ReviewState(level: $level, stability: $stability, difficulty: $difficulty, lastReviewAt: $lastReviewAt, dueAt: $dueAt, reps: $reps, lapses: $lapses, pausedAt: $pausedAt)';
}


}

/// @nodoc
abstract mixin class _$ReviewStateCopyWith<$Res> implements $ReviewStateCopyWith<$Res> {
  factory _$ReviewStateCopyWith(_ReviewState value, $Res Function(_ReviewState) _then) = __$ReviewStateCopyWithImpl;
@override @useResult
$Res call({
 int level, double? stability, double? difficulty, DateTime? lastReviewAt, DateTime? dueAt, int reps, int lapses, DateTime? pausedAt
});




}
/// @nodoc
class __$ReviewStateCopyWithImpl<$Res>
    implements _$ReviewStateCopyWith<$Res> {
  __$ReviewStateCopyWithImpl(this._self, this._then);

  final _ReviewState _self;
  final $Res Function(_ReviewState) _then;

/// Create a copy of ReviewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? stability = freezed,Object? difficulty = freezed,Object? lastReviewAt = freezed,Object? dueAt = freezed,Object? reps = null,Object? lapses = null,Object? pausedAt = freezed,}) {
  return _then(_ReviewState(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,stability: freezed == stability ? _self.stability : stability // ignore: cast_nullable_to_non_nullable
as double?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as double?,lastReviewAt: freezed == lastReviewAt ? _self.lastReviewAt : lastReviewAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,lapses: null == lapses ? _self.lapses : lapses // ignore: cast_nullable_to_non_nullable
as int,pausedAt: freezed == pausedAt ? _self.pausedAt : pausedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ReviewOutcome {

 ReviewState get state; int get levelBefore; int get levelAfter; double get stabilityAfter; DateTime get dueAfter;
/// Create a copy of ReviewOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewOutcomeCopyWith<ReviewOutcome> get copyWith => _$ReviewOutcomeCopyWithImpl<ReviewOutcome>(this as ReviewOutcome, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewOutcome&&(identical(other.state, state) || other.state == state)&&(identical(other.levelBefore, levelBefore) || other.levelBefore == levelBefore)&&(identical(other.levelAfter, levelAfter) || other.levelAfter == levelAfter)&&(identical(other.stabilityAfter, stabilityAfter) || other.stabilityAfter == stabilityAfter)&&(identical(other.dueAfter, dueAfter) || other.dueAfter == dueAfter));
}


@override
int get hashCode => Object.hash(runtimeType,state,levelBefore,levelAfter,stabilityAfter,dueAfter);

@override
String toString() {
  return 'ReviewOutcome(state: $state, levelBefore: $levelBefore, levelAfter: $levelAfter, stabilityAfter: $stabilityAfter, dueAfter: $dueAfter)';
}


}

/// @nodoc
abstract mixin class $ReviewOutcomeCopyWith<$Res>  {
  factory $ReviewOutcomeCopyWith(ReviewOutcome value, $Res Function(ReviewOutcome) _then) = _$ReviewOutcomeCopyWithImpl;
@useResult
$Res call({
 ReviewState state, int levelBefore, int levelAfter, double stabilityAfter, DateTime dueAfter
});


$ReviewStateCopyWith<$Res> get state;

}
/// @nodoc
class _$ReviewOutcomeCopyWithImpl<$Res>
    implements $ReviewOutcomeCopyWith<$Res> {
  _$ReviewOutcomeCopyWithImpl(this._self, this._then);

  final ReviewOutcome _self;
  final $Res Function(ReviewOutcome) _then;

/// Create a copy of ReviewOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,Object? levelBefore = null,Object? levelAfter = null,Object? stabilityAfter = null,Object? dueAfter = null,}) {
  return _then(_self.copyWith(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ReviewState,levelBefore: null == levelBefore ? _self.levelBefore : levelBefore // ignore: cast_nullable_to_non_nullable
as int,levelAfter: null == levelAfter ? _self.levelAfter : levelAfter // ignore: cast_nullable_to_non_nullable
as int,stabilityAfter: null == stabilityAfter ? _self.stabilityAfter : stabilityAfter // ignore: cast_nullable_to_non_nullable
as double,dueAfter: null == dueAfter ? _self.dueAfter : dueAfter // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ReviewOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewStateCopyWith<$Res> get state {
  
  return $ReviewStateCopyWith<$Res>(_self.state, (value) {
    return _then(_self.copyWith(state: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReviewOutcome].
extension ReviewOutcomePatterns on ReviewOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewOutcome value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewOutcome() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewOutcome value)  $default,){
final _that = this;
switch (_that) {
case _ReviewOutcome():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewOutcome value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewOutcome() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReviewState state,  int levelBefore,  int levelAfter,  double stabilityAfter,  DateTime dueAfter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewOutcome() when $default != null:
return $default(_that.state,_that.levelBefore,_that.levelAfter,_that.stabilityAfter,_that.dueAfter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReviewState state,  int levelBefore,  int levelAfter,  double stabilityAfter,  DateTime dueAfter)  $default,) {final _that = this;
switch (_that) {
case _ReviewOutcome():
return $default(_that.state,_that.levelBefore,_that.levelAfter,_that.stabilityAfter,_that.dueAfter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReviewState state,  int levelBefore,  int levelAfter,  double stabilityAfter,  DateTime dueAfter)?  $default,) {final _that = this;
switch (_that) {
case _ReviewOutcome() when $default != null:
return $default(_that.state,_that.levelBefore,_that.levelAfter,_that.stabilityAfter,_that.dueAfter);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewOutcome implements ReviewOutcome {
  const _ReviewOutcome({required this.state, required this.levelBefore, required this.levelAfter, required this.stabilityAfter, required this.dueAfter});
  

@override final  ReviewState state;
@override final  int levelBefore;
@override final  int levelAfter;
@override final  double stabilityAfter;
@override final  DateTime dueAfter;

/// Create a copy of ReviewOutcome
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewOutcomeCopyWith<_ReviewOutcome> get copyWith => __$ReviewOutcomeCopyWithImpl<_ReviewOutcome>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewOutcome&&(identical(other.state, state) || other.state == state)&&(identical(other.levelBefore, levelBefore) || other.levelBefore == levelBefore)&&(identical(other.levelAfter, levelAfter) || other.levelAfter == levelAfter)&&(identical(other.stabilityAfter, stabilityAfter) || other.stabilityAfter == stabilityAfter)&&(identical(other.dueAfter, dueAfter) || other.dueAfter == dueAfter));
}


@override
int get hashCode => Object.hash(runtimeType,state,levelBefore,levelAfter,stabilityAfter,dueAfter);

@override
String toString() {
  return 'ReviewOutcome(state: $state, levelBefore: $levelBefore, levelAfter: $levelAfter, stabilityAfter: $stabilityAfter, dueAfter: $dueAfter)';
}


}

/// @nodoc
abstract mixin class _$ReviewOutcomeCopyWith<$Res> implements $ReviewOutcomeCopyWith<$Res> {
  factory _$ReviewOutcomeCopyWith(_ReviewOutcome value, $Res Function(_ReviewOutcome) _then) = __$ReviewOutcomeCopyWithImpl;
@override @useResult
$Res call({
 ReviewState state, int levelBefore, int levelAfter, double stabilityAfter, DateTime dueAfter
});


@override $ReviewStateCopyWith<$Res> get state;

}
/// @nodoc
class __$ReviewOutcomeCopyWithImpl<$Res>
    implements _$ReviewOutcomeCopyWith<$Res> {
  __$ReviewOutcomeCopyWithImpl(this._self, this._then);

  final _ReviewOutcome _self;
  final $Res Function(_ReviewOutcome) _then;

/// Create a copy of ReviewOutcome
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,Object? levelBefore = null,Object? levelAfter = null,Object? stabilityAfter = null,Object? dueAfter = null,}) {
  return _then(_ReviewOutcome(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ReviewState,levelBefore: null == levelBefore ? _self.levelBefore : levelBefore // ignore: cast_nullable_to_non_nullable
as int,levelAfter: null == levelAfter ? _self.levelAfter : levelAfter // ignore: cast_nullable_to_non_nullable
as int,stabilityAfter: null == stabilityAfter ? _self.stabilityAfter : stabilityAfter // ignore: cast_nullable_to_non_nullable
as double,dueAfter: null == dueAfter ? _self.dueAfter : dueAfter // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ReviewOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewStateCopyWith<$Res> get state {
  
  return $ReviewStateCopyWith<$Res>(_self.state, (value) {
    return _then(_self.copyWith(state: value));
  });
}
}

/// @nodoc
mixin _$ReviewRecord {

 DateTime get at; Rating get rating;/// Tie-breaker for events at the same instant (the row's HLC).
 String get order;
/// Create a copy of ReviewRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewRecordCopyWith<ReviewRecord> get copyWith => _$ReviewRecordCopyWithImpl<ReviewRecord>(this as ReviewRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewRecord&&(identical(other.at, at) || other.at == at)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,at,rating,order);

@override
String toString() {
  return 'ReviewRecord(at: $at, rating: $rating, order: $order)';
}


}

/// @nodoc
abstract mixin class $ReviewRecordCopyWith<$Res>  {
  factory $ReviewRecordCopyWith(ReviewRecord value, $Res Function(ReviewRecord) _then) = _$ReviewRecordCopyWithImpl;
@useResult
$Res call({
 DateTime at, Rating rating, String order
});




}
/// @nodoc
class _$ReviewRecordCopyWithImpl<$Res>
    implements $ReviewRecordCopyWith<$Res> {
  _$ReviewRecordCopyWithImpl(this._self, this._then);

  final ReviewRecord _self;
  final $Res Function(ReviewRecord) _then;

/// Create a copy of ReviewRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = null,Object? rating = null,Object? order = null,}) {
  return _then(_self.copyWith(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as Rating,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewRecord].
extension ReviewRecordPatterns on ReviewRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewRecord value)  $default,){
final _that = this;
switch (_that) {
case _ReviewRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime at,  Rating rating,  String order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewRecord() when $default != null:
return $default(_that.at,_that.rating,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime at,  Rating rating,  String order)  $default,) {final _that = this;
switch (_that) {
case _ReviewRecord():
return $default(_that.at,_that.rating,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime at,  Rating rating,  String order)?  $default,) {final _that = this;
switch (_that) {
case _ReviewRecord() when $default != null:
return $default(_that.at,_that.rating,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewRecord implements ReviewRecord {
  const _ReviewRecord({required this.at, required this.rating, this.order = ''});
  

@override final  DateTime at;
@override final  Rating rating;
/// Tie-breaker for events at the same instant (the row's HLC).
@override@JsonKey() final  String order;

/// Create a copy of ReviewRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewRecordCopyWith<_ReviewRecord> get copyWith => __$ReviewRecordCopyWithImpl<_ReviewRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewRecord&&(identical(other.at, at) || other.at == at)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,at,rating,order);

@override
String toString() {
  return 'ReviewRecord(at: $at, rating: $rating, order: $order)';
}


}

/// @nodoc
abstract mixin class _$ReviewRecordCopyWith<$Res> implements $ReviewRecordCopyWith<$Res> {
  factory _$ReviewRecordCopyWith(_ReviewRecord value, $Res Function(_ReviewRecord) _then) = __$ReviewRecordCopyWithImpl;
@override @useResult
$Res call({
 DateTime at, Rating rating, String order
});




}
/// @nodoc
class __$ReviewRecordCopyWithImpl<$Res>
    implements _$ReviewRecordCopyWith<$Res> {
  __$ReviewRecordCopyWithImpl(this._self, this._then);

  final _ReviewRecord _self;
  final $Res Function(_ReviewRecord) _then;

/// Create a copy of ReviewRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = null,Object? rating = null,Object? order = null,}) {
  return _then(_ReviewRecord(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as Rating,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PauseInterval {

 DateTime get start; DateTime? get end; String get order;
/// Create a copy of PauseInterval
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PauseIntervalCopyWith<PauseInterval> get copyWith => _$PauseIntervalCopyWithImpl<PauseInterval>(this as PauseInterval, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PauseInterval&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,start,end,order);

@override
String toString() {
  return 'PauseInterval(start: $start, end: $end, order: $order)';
}


}

/// @nodoc
abstract mixin class $PauseIntervalCopyWith<$Res>  {
  factory $PauseIntervalCopyWith(PauseInterval value, $Res Function(PauseInterval) _then) = _$PauseIntervalCopyWithImpl;
@useResult
$Res call({
 DateTime start, DateTime? end, String order
});




}
/// @nodoc
class _$PauseIntervalCopyWithImpl<$Res>
    implements $PauseIntervalCopyWith<$Res> {
  _$PauseIntervalCopyWithImpl(this._self, this._then);

  final PauseInterval _self;
  final $Res Function(PauseInterval) _then;

/// Create a copy of PauseInterval
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = freezed,Object? order = null,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PauseInterval].
extension PauseIntervalPatterns on PauseInterval {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PauseInterval value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PauseInterval() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PauseInterval value)  $default,){
final _that = this;
switch (_that) {
case _PauseInterval():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PauseInterval value)?  $default,){
final _that = this;
switch (_that) {
case _PauseInterval() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime start,  DateTime? end,  String order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PauseInterval() when $default != null:
return $default(_that.start,_that.end,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime start,  DateTime? end,  String order)  $default,) {final _that = this;
switch (_that) {
case _PauseInterval():
return $default(_that.start,_that.end,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime start,  DateTime? end,  String order)?  $default,) {final _that = this;
switch (_that) {
case _PauseInterval() when $default != null:
return $default(_that.start,_that.end,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _PauseInterval implements PauseInterval {
  const _PauseInterval({required this.start, this.end, this.order = ''});
  

@override final  DateTime start;
@override final  DateTime? end;
@override@JsonKey() final  String order;

/// Create a copy of PauseInterval
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PauseIntervalCopyWith<_PauseInterval> get copyWith => __$PauseIntervalCopyWithImpl<_PauseInterval>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PauseInterval&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,start,end,order);

@override
String toString() {
  return 'PauseInterval(start: $start, end: $end, order: $order)';
}


}

/// @nodoc
abstract mixin class _$PauseIntervalCopyWith<$Res> implements $PauseIntervalCopyWith<$Res> {
  factory _$PauseIntervalCopyWith(_PauseInterval value, $Res Function(_PauseInterval) _then) = __$PauseIntervalCopyWithImpl;
@override @useResult
$Res call({
 DateTime start, DateTime? end, String order
});




}
/// @nodoc
class __$PauseIntervalCopyWithImpl<$Res>
    implements _$PauseIntervalCopyWith<$Res> {
  __$PauseIntervalCopyWithImpl(this._self, this._then);

  final _PauseInterval _self;
  final $Res Function(_PauseInterval) _then;

/// Create a copy of PauseInterval
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = freezed,Object? order = null,}) {
  return _then(_PauseInterval(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$LevelDisplay {

/// Displayed level: the stored level, one lower while fading.
 int get level;/// Shine as a stripe count.
 int get stripes;/// Overdue with recall below the fading threshold.
 bool get fading;/// Current recall estimate, null when not started.
 double? get retrievability;
/// Create a copy of LevelDisplay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelDisplayCopyWith<LevelDisplay> get copyWith => _$LevelDisplayCopyWithImpl<LevelDisplay>(this as LevelDisplay, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelDisplay&&(identical(other.level, level) || other.level == level)&&(identical(other.stripes, stripes) || other.stripes == stripes)&&(identical(other.fading, fading) || other.fading == fading)&&(identical(other.retrievability, retrievability) || other.retrievability == retrievability));
}


@override
int get hashCode => Object.hash(runtimeType,level,stripes,fading,retrievability);

@override
String toString() {
  return 'LevelDisplay(level: $level, stripes: $stripes, fading: $fading, retrievability: $retrievability)';
}


}

/// @nodoc
abstract mixin class $LevelDisplayCopyWith<$Res>  {
  factory $LevelDisplayCopyWith(LevelDisplay value, $Res Function(LevelDisplay) _then) = _$LevelDisplayCopyWithImpl;
@useResult
$Res call({
 int level, int stripes, bool fading, double? retrievability
});




}
/// @nodoc
class _$LevelDisplayCopyWithImpl<$Res>
    implements $LevelDisplayCopyWith<$Res> {
  _$LevelDisplayCopyWithImpl(this._self, this._then);

  final LevelDisplay _self;
  final $Res Function(LevelDisplay) _then;

/// Create a copy of LevelDisplay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? stripes = null,Object? fading = null,Object? retrievability = freezed,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,stripes: null == stripes ? _self.stripes : stripes // ignore: cast_nullable_to_non_nullable
as int,fading: null == fading ? _self.fading : fading // ignore: cast_nullable_to_non_nullable
as bool,retrievability: freezed == retrievability ? _self.retrievability : retrievability // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [LevelDisplay].
extension LevelDisplayPatterns on LevelDisplay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LevelDisplay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LevelDisplay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LevelDisplay value)  $default,){
final _that = this;
switch (_that) {
case _LevelDisplay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LevelDisplay value)?  $default,){
final _that = this;
switch (_that) {
case _LevelDisplay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int level,  int stripes,  bool fading,  double? retrievability)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LevelDisplay() when $default != null:
return $default(_that.level,_that.stripes,_that.fading,_that.retrievability);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int level,  int stripes,  bool fading,  double? retrievability)  $default,) {final _that = this;
switch (_that) {
case _LevelDisplay():
return $default(_that.level,_that.stripes,_that.fading,_that.retrievability);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int level,  int stripes,  bool fading,  double? retrievability)?  $default,) {final _that = this;
switch (_that) {
case _LevelDisplay() when $default != null:
return $default(_that.level,_that.stripes,_that.fading,_that.retrievability);case _:
  return null;

}
}

}

/// @nodoc


class _LevelDisplay implements LevelDisplay {
  const _LevelDisplay({required this.level, required this.stripes, required this.fading, this.retrievability});
  

/// Displayed level: the stored level, one lower while fading.
@override final  int level;
/// Shine as a stripe count.
@override final  int stripes;
/// Overdue with recall below the fading threshold.
@override final  bool fading;
/// Current recall estimate, null when not started.
@override final  double? retrievability;

/// Create a copy of LevelDisplay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LevelDisplayCopyWith<_LevelDisplay> get copyWith => __$LevelDisplayCopyWithImpl<_LevelDisplay>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LevelDisplay&&(identical(other.level, level) || other.level == level)&&(identical(other.stripes, stripes) || other.stripes == stripes)&&(identical(other.fading, fading) || other.fading == fading)&&(identical(other.retrievability, retrievability) || other.retrievability == retrievability));
}


@override
int get hashCode => Object.hash(runtimeType,level,stripes,fading,retrievability);

@override
String toString() {
  return 'LevelDisplay(level: $level, stripes: $stripes, fading: $fading, retrievability: $retrievability)';
}


}

/// @nodoc
abstract mixin class _$LevelDisplayCopyWith<$Res> implements $LevelDisplayCopyWith<$Res> {
  factory _$LevelDisplayCopyWith(_LevelDisplay value, $Res Function(_LevelDisplay) _then) = __$LevelDisplayCopyWithImpl;
@override @useResult
$Res call({
 int level, int stripes, bool fading, double? retrievability
});




}
/// @nodoc
class __$LevelDisplayCopyWithImpl<$Res>
    implements _$LevelDisplayCopyWith<$Res> {
  __$LevelDisplayCopyWithImpl(this._self, this._then);

  final _LevelDisplay _self;
  final $Res Function(_LevelDisplay) _then;

/// Create a copy of LevelDisplay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? stripes = null,Object? fading = null,Object? retrievability = freezed,}) {
  return _then(_LevelDisplay(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,stripes: null == stripes ? _self.stripes : stripes // ignore: cast_nullable_to_non_nullable
as int,fading: null == fading ? _self.fading : fading // ignore: cast_nullable_to_non_nullable
as bool,retrievability: freezed == retrievability ? _self.retrievability : retrievability // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
