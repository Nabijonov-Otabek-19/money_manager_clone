import 'package:get_it/get_it.dart';
import 'package:money_manager_clone/core/modules/storage_module.dart';

Future initDI() async {
  final di = GetIt.I;

  di.registerLazySingleton(() => StorageModule.providePreferencesStorage());
}
