import '../../../core/utils/constants.dart';

class ExpenseModel {
  final int? id;
  final String title;
  final String description;
  final int number;
  final String type;
  final DateTime createdTime;
  final String? photo;

  const ExpenseModel({
    this.id,
    required this.title,
    required this.description,
    required this.number,
    required this.type,
    required this.createdTime,
    required this.photo,
  });

  ExpenseModel copyWith({
    int? id,
    String? title,
    String? description,
    int? number,
    String? type,
    DateTime? createdTime,
    String? photo,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      number: number ?? this.number,
      type: type ?? this.type,
      createdTime: createdTime ?? this.createdTime,
      photo: photo ?? this.photo,
    );
  }

  static ExpenseModel fromJson(Map<String, Object?> json) => ExpenseModel(
        id: json[ExpenseFields.id] as int?,
        title: json[ExpenseFields.title] as String,
        description: json[ExpenseFields.description] as String,
        number: json[ExpenseFields.number] as int,
        type: json[ExpenseFields.type] as String,
        createdTime: DateTime.parse(json[ExpenseFields.createdTime] as String),
        photo: json[ExpenseFields.photo] as String,
      );

  Map<String, Object?> toJson() => {
        ExpenseFields.id: id,
        ExpenseFields.title: title,
        ExpenseFields.description: description,
        ExpenseFields.number: number,
        ExpenseFields.type: type,
        ExpenseFields.createdTime: createdTime.toIso8601String(),
        ExpenseFields.photo: photo,
      };
}
