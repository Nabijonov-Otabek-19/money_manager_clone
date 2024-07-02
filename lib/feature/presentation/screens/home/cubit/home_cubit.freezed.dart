// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeState {
  LoadState get loadState => throw _privateConstructorUsedError;
  List<DayModel> get dayModels => throw _privateConstructorUsedError;
  int get currentMonthExpense => throw _privateConstructorUsedError;
  int get currentMonthIncome => throw _privateConstructorUsedError;
  int get currentMonthBalance => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {LoadState loadState,
      List<DayModel> dayModels,
      int currentMonthExpense,
      int currentMonthIncome,
      int currentMonthBalance});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadState = null,
    Object? dayModels = null,
    Object? currentMonthExpense = null,
    Object? currentMonthIncome = null,
    Object? currentMonthBalance = null,
  }) {
    return _then(_value.copyWith(
      loadState: null == loadState
          ? _value.loadState
          : loadState // ignore: cast_nullable_to_non_nullable
              as LoadState,
      dayModels: null == dayModels
          ? _value.dayModels
          : dayModels // ignore: cast_nullable_to_non_nullable
              as List<DayModel>,
      currentMonthExpense: null == currentMonthExpense
          ? _value.currentMonthExpense
          : currentMonthExpense // ignore: cast_nullable_to_non_nullable
              as int,
      currentMonthIncome: null == currentMonthIncome
          ? _value.currentMonthIncome
          : currentMonthIncome // ignore: cast_nullable_to_non_nullable
              as int,
      currentMonthBalance: null == currentMonthBalance
          ? _value.currentMonthBalance
          : currentMonthBalance // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
          _$HomeStateImpl value, $Res Function(_$HomeStateImpl) then) =
      __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LoadState loadState,
      List<DayModel> dayModels,
      int currentMonthExpense,
      int currentMonthIncome,
      int currentMonthBalance});
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
      _$HomeStateImpl _value, $Res Function(_$HomeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadState = null,
    Object? dayModels = null,
    Object? currentMonthExpense = null,
    Object? currentMonthIncome = null,
    Object? currentMonthBalance = null,
  }) {
    return _then(_$HomeStateImpl(
      loadState: null == loadState
          ? _value.loadState
          : loadState // ignore: cast_nullable_to_non_nullable
              as LoadState,
      dayModels: null == dayModels
          ? _value._dayModels
          : dayModels // ignore: cast_nullable_to_non_nullable
              as List<DayModel>,
      currentMonthExpense: null == currentMonthExpense
          ? _value.currentMonthExpense
          : currentMonthExpense // ignore: cast_nullable_to_non_nullable
              as int,
      currentMonthIncome: null == currentMonthIncome
          ? _value.currentMonthIncome
          : currentMonthIncome // ignore: cast_nullable_to_non_nullable
              as int,
      currentMonthBalance: null == currentMonthBalance
          ? _value.currentMonthBalance
          : currentMonthBalance // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl(
      {this.loadState = LoadState.loaded,
      final List<DayModel> dayModels = const [],
      this.currentMonthExpense = 0,
      this.currentMonthIncome = 0,
      this.currentMonthBalance = 0})
      : _dayModels = dayModels;

  @override
  @JsonKey()
  final LoadState loadState;
  final List<DayModel> _dayModels;
  @override
  @JsonKey()
  List<DayModel> get dayModels {
    if (_dayModels is EqualUnmodifiableListView) return _dayModels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dayModels);
  }

  @override
  @JsonKey()
  final int currentMonthExpense;
  @override
  @JsonKey()
  final int currentMonthIncome;
  @override
  @JsonKey()
  final int currentMonthBalance;

  @override
  String toString() {
    return 'HomeState(loadState: $loadState, dayModels: $dayModels, currentMonthExpense: $currentMonthExpense, currentMonthIncome: $currentMonthIncome, currentMonthBalance: $currentMonthBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.loadState, loadState) ||
                other.loadState == loadState) &&
            const DeepCollectionEquality()
                .equals(other._dayModels, _dayModels) &&
            (identical(other.currentMonthExpense, currentMonthExpense) ||
                other.currentMonthExpense == currentMonthExpense) &&
            (identical(other.currentMonthIncome, currentMonthIncome) ||
                other.currentMonthIncome == currentMonthIncome) &&
            (identical(other.currentMonthBalance, currentMonthBalance) ||
                other.currentMonthBalance == currentMonthBalance));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loadState,
      const DeepCollectionEquality().hash(_dayModels),
      currentMonthExpense,
      currentMonthIncome,
      currentMonthBalance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {final LoadState loadState,
      final List<DayModel> dayModels,
      final int currentMonthExpense,
      final int currentMonthIncome,
      final int currentMonthBalance}) = _$HomeStateImpl;

  @override
  LoadState get loadState;
  @override
  List<DayModel> get dayModels;
  @override
  int get currentMonthExpense;
  @override
  int get currentMonthIncome;
  @override
  int get currentMonthBalance;
  @override
  @JsonKey(ignore: true)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
