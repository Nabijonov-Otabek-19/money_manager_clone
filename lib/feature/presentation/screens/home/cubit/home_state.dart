part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(LoadState.loaded) LoadState loadState,
    @Default([]) List<MonthModel> list,
    @Default(0) int currentMonthExpense,
    @Default(0) int currentMonthIncome,
    @Default(0) int currentMonthBalance,
  }) = _HomeState;
}
