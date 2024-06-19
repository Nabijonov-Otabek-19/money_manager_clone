part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(LoadState.loaded) LoadState loadState,
    @Default([]) List<ExpenseModel> list,
    @Default(0) int expense,
    @Default(0) int income,
    @Default(0) int balance,
  }) = _HomeState;
}

enum LoadState { loading, loaded }
