part of 'chart_cubit.dart';

@freezed
class ChartState with _$ChartState {
  const factory ChartState({
    @Default(LoadState.loaded) LoadState loadState,
    @Default(0) int totalExpense,
    @Default([]) List<ExpenseModel> list,
    @Default("Expense") String moneyType,
  }) = _ChartState;
}
