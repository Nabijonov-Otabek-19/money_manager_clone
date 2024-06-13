import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class AppPreferences {
  final Box _box;

  AppPreferences({required Box box}) : _box = box;

  Map<String, String> languageMap = {
    "Русский": "ru",
    "O'zbek": "uz",
    "English": "en",
  };

  String? get lang => _box.get("lang");

  set lang(String? newLang) {
    String localeCode = languageMap[newLang ?? "English"] ?? "en";
    _box.put("lang", localeCode);
  }

  ThemeMode get theme {
    final val = _box.get("theme_mode", defaultValue: "light");
    return _parseTheme(val);
  }

  set theme(ThemeMode value) =>
      _box.put("theme_mode", value.toString().split('.')[1]);

  ThemeMode _parseTheme(String theme) {
    if (theme == "light") {
      return ThemeMode.light;
    } else if (theme == "dark") {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  void handleThemeSelection(String value) {
    ThemeMode selectedTheme = _parseTheme(value.toLowerCase());
    Get.changeThemeMode(selectedTheme);
    theme = selectedTheme; // Using the setter to save theme
  }

  void changeTheme(bool value) {
    final selectedTheme = value ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(selectedTheme);
    theme = selectedTheme;
  }
}

extension PreferencesExtension on AppPreferences {
  ValueListenable<Box> themeListenable() =>
      _box.listenable(keys: ['theme_mode']);
}
