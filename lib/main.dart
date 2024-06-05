import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager_clone/feature/presentation/screens/splash/splash_screen.dart';
import 'package:money_manager_clone/main_cubit/app_cubit.dart';
import 'package:money_manager_clone/feature/presentation/routes/app_routes.dart';

import 'core/extensions/my_extensions.dart';
import 'core/modules/app_module.dart';
import 'core/modules/storage_module.dart';
import 'feature/data/datasources/app_preference.dart';
import 'feature/presentation/themes/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = inject<AppPreferences>();

    return BlocProvider(
      create: (context) => AppCubit(
        isDarkMode: preferences.theme == ThemeMode.dark,
      ),
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen: (pr, cr) => pr.isDarkMode != cr.isDarkMode,
        builder: (context, state) {
          return MaterialApp(
            title: 'Money manager clone',
            themeMode: preferences.theme,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child ?? Container(),
              );
            },
            onGenerateRoute: (settings) => RouteManager.generateRoute(settings),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }

  Widget _unFocusWrapper(Widget? child) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
