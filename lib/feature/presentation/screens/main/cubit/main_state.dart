part of 'main_cubit.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    @Default(LoadState.loaded) LoadState loadState,
    @Default(0) int selectedIndex,
    @Default([]) List<DayModel> dayModels,
    @Default(0) int currentMonthExpense,
    @Default(0) int currentMonthIncome,
    @Default(0) int currentMonthBalance,
    @Default(0) int totalExpense,
    @Default([]) List<ExpenseModel> list,
    @Default("Expense") String moneyType,
}) = _MainState;
}
