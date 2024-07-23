import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager_clone/feature/presentation/screens/splash/splash_screen.dart';
import 'package:money_manager_clone/feature/presentation/routes/app_routes.dart';
import 'package:upgrader/upgrader.dart';

import 'core/extensions/my_extensions.dart';
import 'core/modules/app_module.dart';
import 'core/modules/storage_module.dart';
import 'core/translations/app_translation.dart';
import 'feature/data/datasources/app_preference.dart';
import 'feature/presentation/themes/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Only call clearSavedSettings() during testing to reset internal values.
  //await Upgrader.clearSavedSettings(); // REMOVE this for release builds

  await Hive.initFlutter();
  await StorageModule.initBoxes();
  await initDI();

  // When some error occurs,
  // screen will show custom error widget, not red screen
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flexible(
                  child: Text(
                    kReleaseMode
                        ? "Oops... something went wrong"
                        : errorDetails.exception.toString(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final preferences = inject<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: preferences.themeListenable(),
      builder: (context, value, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Money manager clone',
          themeMode: preferences.theme,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          fallbackLocale: const Locale('en', 'EN'),
          locale: Locale(preferences.lang!),
          translations: AppTranslation(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child ?? Container(),
            );
          },
          onGenerateRoute: (settings) => RouteManager.generateRoute(settings),
          home: UpgradeAlert(
            upgrader: Upgrader(
              debugLogging: true,
              debugDisplayAlways: true,
              languageCode: 'en',
              messages: UpgraderMessages(code: 'en'),
              countryCode: "UZ",
              durationUntilAlertAgain: const Duration(days: 1),
            ),
            showLater: true,
            showIgnore: false,
            showReleaseNotes: true,
            shouldPopScope: () => true,
            dialogStyle: UpgradeDialogStyle.material,
            child: const SplashScreen(),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    initTools(context);
    super.didChangeDependencies();
  }

  void initTools(BuildContext context) async {
    preferences.lang ??= "English";
  }
}
