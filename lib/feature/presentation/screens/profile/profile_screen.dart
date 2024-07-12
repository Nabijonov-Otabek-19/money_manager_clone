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
        toolbarHeight: 180,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              radius: 40,
              child: const Icon(
                Icons.person,
                size: 40,
                color: Color(AppColors.orange),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Username".tr,
              style: pmedium.copyWith(fontSize: 20),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  "Version : 1.0.0",
                  style: pregular.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 8),
                _buildThemeChangeItem(),
                const SizedBox(height: 4),
                _buildLanguageChangeItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeChangeItem() {
    return Card(
      elevation: 1,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
                fontSize: 16,
                color: Theme.of(context).canvasColor,
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
      elevation: 1,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
                fontSize: 16,
                color: Theme.of(context).canvasColor,
              ),
            ),
            InkWell(
              //splashColor: AppColors.transparent,
              highlightColor: AppColors.transparent,
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // show menu button
                dynamic state = _menuKeyLang.currentState;
                state
                    .showButtonMenu(); // This opens the dropdown menu programmatically.
              },
              child: PopupMenuButton<String>(
                surfaceTintColor: AppColors.transparent,
                shadowColor: AppColors.transparent,
                key: _menuKeyLang,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  currentLang,
                  style: pregular.copyWith(
                    fontSize: 14,
                    color: Theme.of(context).canvasColor,
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
            ),
          ],
        ),
      ),
    );
  }
}
