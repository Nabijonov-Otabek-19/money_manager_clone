import 'package:flutter/material.dart';
import 'package:money_manager_clone/feature/data/models/my_model.dart';
import '../screens/screens.dart';

class RouteManager {
  static generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    const duration = Duration(milliseconds: 200);

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );
      case '/main':
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );
      case '/add':
        return PageRouteBuilder(
          transitionDuration: duration,
          pageBuilder: (context, animation, secondaryAnimation) {
            return AddEditScreen(model: args as ExpenseModel?);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      case '/detail':
        return PageRouteBuilder(
          transitionDuration: duration,
          pageBuilder: (context, animation, secondaryAnimation) {
            return DetailScreen(modelId: args as int);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      case '/search':
        return PageRouteBuilder(
          transitionDuration: duration,
          pageBuilder: (context, animation, secondaryAnimation) {
            return const SearchScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
    }
  }
}
