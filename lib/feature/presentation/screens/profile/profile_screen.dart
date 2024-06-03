import 'package:flutter/material.dart';
import 'package:money_manager_clone/feature/presentation/themes/fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            "Profile screen",
            style: pregular.copyWith(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
