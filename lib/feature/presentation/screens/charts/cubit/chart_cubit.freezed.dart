// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chart_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChartState {
  LoadState get loadState => throw _privateConstructorUsedError;
  int get totalExpense => throw _privateConstructorUsedError;
  List<ExpenseModel> get list => throw _privateConstructorUsedError;
  String get moneyType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChartStateCopyWith<ChartState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartStateCopyWith<$Res> {
  factory $ChartStateCopyWith(
          ChartState value, $Res Function(ChartState) then) =
      _$ChartStateCopyWithImpl<$Res, ChartState>;
  @useResult
  $Res call(
      {LoadState loadState,
      int totalExpense,
      List<ExpenseModel> list,
      String moneyType});
}

/// @nodoc
class _$ChartStateCopyWithImpl<$Res, $Val extends ChartState>
    implements $ChartStateCopyWith<$Res> {
  _$ChartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadState = null,
    Object? totalExpense = null,
    Object? list = null,
    Object? moneyType = null,
  }) {
    return _then(_value.copyWith(
      loadState: null == loadState
          ? _value.loadState
          : loadState // ignore: cast_nullable_to_non_nullable
              as LoadState,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int,
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ExpenseModel>,
      moneyType: null == moneyType
          ? _value.moneyType
          : moneyType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChartStateImplCopyWith<$Res>
    implements $ChartStateCopyWith<$Res> {
  factory _$$ChartStateImplCopyWith(
          _$ChartStateImpl value, $Res Function(_$ChartStateImpl) then) =
      __$$ChartStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LoadState loadState,
      int totalExpense,
      List<ExpenseModel> list,
      String moneyType});
}

/// @nodoc
class __$$ChartStateImplCopyWithImpl<$Res>
    extends _$ChartStateCopyWithImpl<$Res, _$ChartStateImpl>
    implements _$$ChartStateImplCopyWith<$Res> {
  __$$ChartStateImplCopyWithImpl(
      _$ChartStateImpl _value, $Res Function(_$ChartStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadState = null,
    Object? totalExpense = null,
    Object? list = null,
    Object? moneyType = null,
  }) {
    return _then(_$ChartStateImpl(
      loadState: null == loadState
          ? _value.loadState
          : loadState // ignore: cast_nullable_to_non_nullable
              as LoadState,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int,
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ExpenseModel>,
      moneyType: null == moneyType
          ? _value.moneyType
          : moneyType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ChartStateImpl implements _ChartState {
  const _$ChartStateImpl(
      {this.loadState = LoadState.loaded,
      this.totalExpense = 0,
      final List<ExpenseModel> list = const [],
      this.moneyType = "Expense"})
      : _list = list;

  @override
  @JsonKey()
  final LoadState loadState;
  @override
  @JsonKey()
  final int totalExpense;
  final List<ExpenseModel> _list;
  @override
  @JsonKey()
  List<ExpenseModel> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  @JsonKey()
  final String moneyType;

  @override
  String toString() {
    return 'ChartState(loadState: $loadState, totalExpense: $totalExpense, list: $list, moneyType: $moneyType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartStateImpl &&
            (identical(other.loadState, loadState) ||
                other.loadState == loadState) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            (identical(other.moneyType, moneyType) ||
                other.moneyType == moneyType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loadState, totalExpense,
      const DeepCollectionEquality().hash(_list), moneyType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartStateImplCopyWith<_$ChartStateImpl> get copyWith =>
      __$$ChartStateImplCopyWithImpl<_$ChartStateImpl>(this, _$identity);
}

abstract class _ChartState implements ChartState {
  const factory _ChartState(
      {final LoadState loadState,
      final int totalExpense,
      final List<ExpenseModel> list,
      final String moneyType}) = _$ChartStateImpl;

  @override
  LoadState get loadState;
  @override
  int get totalExpense;
  @override
  List<ExpenseModel> get list;
  @override
  String get moneyType;
  @override
  @JsonKey(ignore: true)
  _$$ChartStateImplCopyWith<_$ChartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
