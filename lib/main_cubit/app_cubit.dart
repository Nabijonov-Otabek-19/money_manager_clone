import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/data/datasources/app_preference.dart';

part 'app_state.dart';

part 'app_cubit.freezed.dart';

class AppCubit extends Cubit<AppState> {
  final bool isDarkMode;

  AppCubit({required this.isDarkMode})
      : super(AppState(isDarkMode: isDarkMode));

  final _preference = inject<AppPreferences>();

  void updateTheme(bool value) {
    _preference.theme = value ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(isDarkMode: value));
  }
}
