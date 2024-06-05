import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/data/datasources/app_preference.dart';
import 'package:money_manager_clone/feature/presentation/themes/colors.dart';
import 'package:money_manager_clone/feature/presentation/themes/fonts.dart';
import 'package:money_manager_clone/main_cubit/app_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey _menuKeyTheme = GlobalKey();

  final List<String> list = ["Uzbek", "English", "Russian"];

  final preferences = inject<AppPreferences>();

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
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.orange,
                  ),
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
      color: Theme.of(context).cardColor,
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
              style: pmedium.copyWith(
                fontSize: 18,
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              ),
            ),
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return Switch(
                  value: state.isDarkMode,
                  activeColor: Colors.deepOrangeAccent,
                  activeTrackColor: Colors.orangeAccent,
                  inactiveTrackColor: Colors.grey.shade300,
                  inactiveThumbColor: Colors.grey,
                  trackOutlineColor: WidgetStatePropertyAll(
                    state.isDarkMode ? Colors.orange : Colors.grey,
                  ),
                  onChanged: (value) {
                    BlocProvider.of<AppCubit>(context).updateTheme(value);
                  },
                );
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
      color: Theme.of(context).cardColor,
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
              style: pmedium.copyWith(
                fontSize: 18,
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              ),
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
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color,
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
