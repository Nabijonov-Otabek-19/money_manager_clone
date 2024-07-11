import 'dart:ui';

import '../../feature/presentation/themes/colors.dart';

class ExpenseFields {
  static const expenseTableName = "expenses";
  static const dayTableName = "days";
  static const monthTableName = "months";

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
  "Gift",
  "Bills",
  "Shopping",
  "Electronics",
  "Travel",
  "Donate",
  "Salary",
  "Investment",
  "Awards",
  "Others",
];

final titleExpenseList = [
  "Snack",
  "Health",
  "Food",
  "Beauty",
  "Transportation",
  "Education",
  "Gift",
  "Bills",
  "Shopping",
  "Electronics",
  "Travel",
  "Donate",
];
final titleIncomeList = [
  "Salary",
  "Investment",
  "Awards",
  "Others",
];

final iconExpenseList = [
  "snack",
  "health",
  "food",
  "beauty",
  "transportation",
  "education",
  "gift",
  "bills",
  "shopping",
  "electronics",
  "travel",
  "donate",
];
final iconIncomeList = [
  "salary",
  "investment",
  "awards",
  "others",
];

Map<String, int> expenseTypeMap = {
  "Snack": 0,
  "Health": 1,
  "Food": 2,
  "Beauty": 3,
  "Transportation": 4,
  "Education": 5,
  "Gift": 6,
  "Bills": 7,
  "Shopping": 8,
  "Electronics": 9,
  "Travel": 10,
  "Donate": 11,
};
Map<String, int> incomeTypeMap = {
  "Salary": 0,
  "Investment": 1,
  "Awards": 2,
  "Others": 3,
};
