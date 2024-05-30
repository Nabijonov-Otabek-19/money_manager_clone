import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../home/cubit/home_cubit.dart';

part 'main_state.dart';

part 'main_cubit.freezed.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  void onTappedScreen(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
