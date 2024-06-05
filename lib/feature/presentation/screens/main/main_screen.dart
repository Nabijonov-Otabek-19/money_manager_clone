import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/presentation/screens/charts/chart_screen.dart';
import 'package:money_manager_clone/feature/presentation/screens/home/home_screen.dart';
import 'package:money_manager_clone/feature/presentation/screens/main/cubit/main_cubit.dart';
import 'package:money_manager_clone/feature/presentation/screens/profile/profile_screen.dart';
import 'package:money_manager_clone/feature/presentation/screens/report/report_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final screens = const <Widget>[
    HomeScreen(),
    ChartScreen(),
    ReportScreen(),
    ProfileScreen(),
  ];

  final cubit = MainCubit();

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<MainCubit, MainState>(
        buildWhen: (pr, cr) => pr.selectedIndex != cr.selectedIndex,
        builder: (context, state) {
          return PopScope(
            canPop: state.selectedIndex == 0,
            onPopInvoked: (didPop) {
              if (!didPop) {
                cubit.onTappedScreen(0);
              }
            },
            child: Scaffold(
              body: IndexedStack(
                index: state.selectedIndex,
                children: screens,
              ),
              bottomNavigationBar: BottomNavigationBar(
                elevation: theme.bottomNavigationBarTheme.elevation,
                backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
                selectedItemColor:
                    theme.bottomNavigationBarTheme.selectedItemColor,
                unselectedItemColor:
                    theme.bottomNavigationBarTheme.unselectedItemColor,
                type: BottomNavigationBarType.fixed,
                currentIndex: state.selectedIndex,
                onTap: (value) => cubit.onTappedScreen(value),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_chart),
                    label: "Chart",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.request_page_outlined),
                    label: "Report",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
