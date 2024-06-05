import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'fonts.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.orange,
    cardColor: Colors.white,
    textTheme: const TextTheme(),
    fontFamily: 'Poppinsregular',
    scaffoldBackgroundColor: AppColors.scaffoldBackLight,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: AppColors.black),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: pregular.copyWith(
        color: AppColors.black,
        fontSize: 20,
      ),
      color: AppColors.orange,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 12,
      selectedItemColor: Colors.orangeAccent,
      unselectedItemColor: Colors.grey,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.orange,
    cardColor: Colors.grey.shade600,
    fontFamily: 'Poppinsregular',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.scaffoldBackDark,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: AppColors.white),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: pregular.copyWith(
        color: AppColors.white,
        fontSize: 20,
      ),
      color: AppColors.orange,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      elevation: 12,
      selectedItemColor: Colors.orangeAccent,
      unselectedItemColor: Colors.grey,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      border: UnderlineInputBorder(),
    ),
  );
}
