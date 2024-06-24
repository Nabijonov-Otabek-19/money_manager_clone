import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens.dart';
import 'cubit/main_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final screens = const <Widget>[
    HomeScreen(),
    ChartScreen(),
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
