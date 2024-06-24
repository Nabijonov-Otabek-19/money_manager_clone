import 'dart:ui';

import '../../feature/presentation/themes/colors.dart';

class ExpenseFields {
  static const tableName = "my_expense";

  static const id = "id";
  static const dayId = "dayId";
  static const title = "title";
  static const icon = "icon";
  static const number = "number";
  static const type = "type";
  static const note = "note";
  static const createdTime = "time";
  static const photo = "photo";

  static final List<String> values = [
    /// Add all fields
    id, title, icon, number, type, note, createdTime, photo, dayId,
  ];
}

final List<Color> colorList = [
  AppColors.blue,
  AppColors.yellow,
  AppColors.purple,
  AppColors.green,
  AppColors.pink,
  AppColors.orange,
];

final List<String> allTypeList = [
  "Snack",
  "Health",
  "Food",
  "Beauty",
  "Transportation",
  "Education",
  "Salary",
  "Investment",
  "Awards",
  "Others",
];
