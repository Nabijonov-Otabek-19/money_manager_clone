import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../feature/data/datasources/app_preference.dart';

T inject<T extends Object>() => GetIt.I.get<T>();

Future<T> injectAsync<T extends Object>() async => GetIt.I.getAsync<T>();

extension ContextExtensions on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;

  bool get isDarkThemeMode {
    final appTheme = inject<AppPreferences>().theme;
    return appTheme == ThemeMode.dark;
  }
}

extension AssetExtension on String {
  String get pngIcon => 'assets/images/$this.png';

  String get svgIcon => 'assets/images/$this.svg';

  String get jpgIcon => 'assets/images/$this.jpg';
}
