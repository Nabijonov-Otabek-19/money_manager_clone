part of 'main_cubit.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    @Default(LoadState.loaded) LoadState loadState,
    @Default(0) int selectedIndex,
}) = _MainState;
}
