import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/data/datasources/app_preference.dart';
import 'package:money_manager_clone/feature/presentation/themes/colors.dart';
import 'package:money_manager_clone/feature/presentation/themes/fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final preferences = inject<AppPreferences>();
  final GlobalKey _menuKeyLang = GlobalKey();
  String currentLang = "";

  final List<String> languages = ["Русский", "O'zbek", "English"];

  Map<String, String> languageMap = {
    "Русский": "ru",
    "O'zbek": "uz",
    "English": "en",
  };

  @override
  Widget build(BuildContext context) {
    if (Get.locale?.languageCode == 'ru') {
      currentLang = languages[0];
    } else if (Get.locale?.languageCode == 'uz') {
      currentLang = languages[1];
    } else {
      currentLang = languages[2];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile".tr),
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
                  "Username".tr,
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
              "Theme".tr,
              style: pmedium.copyWith(
                fontSize: 18,
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              ),
            ),
             Switch(
                  value: context.isDarkMode,
                  activeColor: Colors.deepOrangeAccent,
                  activeTrackColor: Colors.orangeAccent,
                  inactiveTrackColor: Colors.grey.shade300,
                  inactiveThumbColor: Colors.grey,
                  trackOutlineColor: WidgetStatePropertyAll(
                    context.isDarkMode ? Colors.orange : Colors.grey,
                  ),
                  onChanged: (value) {
                    preferences.changeTheme(value);
                    //setState(() {});
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
              "Language".tr,
              style: pmedium.copyWith(
                fontSize: 18,
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              ),
            ),
            PopupMenuButton<String>(
              surfaceTintColor: AppColors.transparent,
              key: _menuKeyLang,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                currentLang,
                style: pregular.copyWith(
                  fontSize: 16,
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                ),
              ),
              itemBuilder: (context) {
                return languages.map((choice) {
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
                String localeCode = languageMap[value] ?? "en";
                Get.updateLocale(Locale(localeCode));
                preferences.lang = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
