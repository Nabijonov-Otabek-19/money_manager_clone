part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(LoadState.loaded) LoadState loadState,
    @Default([]) List<ExpenseModel> list,
  }) = _HomeState;
}

enum LoadState { loading, loaded }
