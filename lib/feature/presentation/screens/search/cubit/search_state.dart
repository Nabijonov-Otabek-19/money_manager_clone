part of 'search_cubit.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    @Default(LoadState.loaded) LoadState loadState,
    @Default([]) List<ExpenseModel> list,
}) = _SearchState;
}
