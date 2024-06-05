import 'package:hive/hive.dart';

import '../../feature/data/datasources/app_preference.dart';

class StorageModule {
  static Future<void> initBoxes() async {
    await Hive.openBox("preferences");
  }

  static AppPreferences providePreferencesStorage() {
    final box = Hive.box("preferences");
    return AppPreferences(box: box);
  }
}
