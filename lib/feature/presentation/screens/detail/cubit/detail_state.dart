part of 'detail_cubit.dart';

@freezed
class DetailState with _$DetailState {
  const factory DetailState({
    ExpenseModel? model,
    @Default(LoadState.loaded) LoadState loadState,
  }) = _Detail;
}
