import 'package:flutter/material.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';

import '../../themes/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  void navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.orange,
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Center(
        child: Image.asset(
          'empty'.pngIcon,
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
