import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/data/datasources/app_preference.dart';
import 'package:money_manager_clone/feature/presentation/themes/colors.dart';
import 'package:money_manager_clone/feature/presentation/themes/fonts.dart';

import '../main/cubit/main_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final preferences = inject<AppPreferences>();
  final GlobalKey _menuKeyLang = GlobalKey();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String currentLang = "";

  String icon = "guest";
  String userName = "";

  late MainCubit mainCubit;

  final List<String> languages = ["Русский", "O'zbek", "English"];

  Map<String, String> languageMap = {
    "Русский": "ru",
    "O'zbek": "uz",
    "English": "en",
  };

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Get.locale?.languageCode == 'ru') {
      currentLang = languages[0];
    } else if (Get.locale?.languageCode == 'uz') {
      currentLang = languages[1];
    } else {
      currentLang = languages[2];
    }

    userName = preferences.userName;
    icon = preferences.userIcon;
    _controller.text = preferences.userName;

    mainCubit = context.read<MainCubit>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 180,
        title: InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: () async {
            await _openEditUserInfoDialog(context).whenComplete(
              () {
                setState(() {});
              },
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 40,
                child: preferences.userIcon.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 40,
                        color: Color(AppColors.orange),
                      )
                    : Image.asset(
                        preferences.userIcon.pngIcon,
                        width: 100,
                        height: 100,
                      ),
              ),
              const SizedBox(height: 12),
              Text(
                preferences.userName.isEmpty
                    ? "Username".tr
                    : preferences.userName,
                style: pmedium.copyWith(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _buildThemeChangeItem(),
                const SizedBox(height: 4),
                _buildLanguageChangeItem(),
                const SizedBox(height: 4),
                _buildClearDatabaseItem(),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openEditUserInfoDialog(BuildContext ctx) async {
    return await showDialog<void>(
      context: ctx,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          final isMale = icon == "male";
          return SimpleDialog(
            insetPadding: const EdgeInsets.all(12),
            contentPadding: const EdgeInsets.all(12),
            surfaceTintColor: AppColors.transparent,
            backgroundColor: ctx.isDarkThemeMode
                ? AppColors.scaffoldBackDark
                : AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              "Change_info".tr,
              style: pmedium.copyWith(
                fontSize: 20,
                color: Theme.of(context).canvasColor,
              ),
              textAlign: TextAlign.center,
            ),
            children: [
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    splashColor: AppColors.transparent,
                    highlightColor: AppColors.transparent,
                    onTap: () {
                      _focusNode.unfocus();
                      setState(() {
                        icon = "male";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: isMale
                              ? const Color(AppColors.orange)
                              : AppColors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Image.asset(
                        "male".pngIcon,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: AppColors.transparent,
                    highlightColor: AppColors.transparent,
                    onTap: () {
                      _focusNode.unfocus();
                      setState(() {
                        icon = "female";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: isMale
                              ? AppColors.transparent
                              : const Color(AppColors.orange),
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Image.asset(
                        "female".pngIcon,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.text,
                decoration: _inputDecoration("Username".tr),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  final name = _controller.text.trim();
                  final gender = icon.isNotEmpty;
                  if (name.isNotEmpty && gender) {
                    preferences.userName = name;
                    preferences.userIcon = icon;
                    _controller.clear();
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Save".tr,
                      style: pregular.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: pregular.copyWith(
        fontSize: 14,
        color: Colors.grey,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildClearDatabaseItem() {
    return InkWell(
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      onTap: () async {
        await _openSimpleDialog();
      },
      child: Card(
        elevation: 1,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Clear_data".tr,
                style: pmedium.copyWith(
                  fontSize: 16,
                  color: Theme.of(context).canvasColor,
                ),
              ),
              const Icon(Icons.keyboard_arrow_right, size: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openSimpleDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          surfaceTintColor: AppColors.transparent,
          backgroundColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Attention".tr,
            style: pmedium.copyWith(
              fontSize: 18,
              color: Theme.of(context).canvasColor,
            ),
            textAlign: TextAlign.center,
          ),
          children: [
            const SizedBox(height: 20),
            Text(
              "Delete_all_data_msg".tr,
              style: pregular.copyWith(
                fontSize: 16,
                color: Theme.of(context).canvasColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      minimumSize: const WidgetStatePropertyAll(
                        Size.fromHeight(45),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await mainCubit.clearDatabase();
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Text(
                      "Delete".tr,
                      style: pregular.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      minimumSize: const WidgetStatePropertyAll(
                        Size.fromHeight(45),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel".tr,
                      style: pregular.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeChangeItem() {
    return Card(
      elevation: 1,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(12),
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
