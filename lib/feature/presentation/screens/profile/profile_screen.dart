import 'package:flutter/material.dart';
import 'package:money_manager_clone/feature/presentation/themes/colors.dart';
import 'package:money_manager_clone/feature/presentation/themes/fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDark = false;
  final GlobalKey _menuKeyTheme = GlobalKey();

  final List<String> list = ["Uzbek", "English", "Russian"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  radius: 40,
                  child: const Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 20),
                Text(
                  "Username",
                  style: pmedium.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 40),
                _buildThemeChangeItem(),
                const SizedBox(height: 4),
                _buildLanguageChangeItem(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeChangeItem() {
    return Card(
      elevation: 4,
      color: Colors.grey.shade200,
      surfaceTintColor: Colors.grey.shade200,
      shadowColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Theme",
              style: pmedium.copyWith(fontSize: 18),
            ),
            Switch(
              value: isDark,
              activeColor: Colors.deepOrangeAccent,
              activeTrackColor: Colors.orangeAccent,
              inactiveTrackColor: Colors.grey.shade300,
              inactiveThumbColor: Colors.grey,
              trackOutlineColor: WidgetStatePropertyAll(
                isDark ? Colors.orange : Colors.grey,
              ),
              onChanged: (value) {
                setState(() {
                  isDark = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageChangeItem() {
    return Card(
      elevation: 4,
      color: Colors.grey.shade200,
      surfaceTintColor: Colors.grey.shade200,
      shadowColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Language",
              style: pmedium.copyWith(fontSize: 18),
            ),
            PopupMenuButton<String>(
              surfaceTintColor: AppColors.transparent,
              key: _menuKeyTheme,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Light",
                style: pregular.copyWith(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              itemBuilder: (context) {
                return list.map((choice) {
                  return PopupMenuItem(
                    value: choice,
                    child: Text(
                      choice,
                      style: pregular.copyWith(fontSize: 14),
                    ),
                  );
                }).toList();
              },
              onSelected: (value) {
                //
              },
            ),
          ],
        ),
      ),
    );
  }
}
