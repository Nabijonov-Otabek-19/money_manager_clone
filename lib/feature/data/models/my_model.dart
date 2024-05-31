import '../../../core/utils/constants.dart';

class ExpenseModel {
  final int? id;
  final String title;
  final int number;
  final String type;
  final String note;
  final DateTime createdTime;
  final String? photo;

  const ExpenseModel({
    this.id,
    required this.title,
    required this.number,
    required this.type,
    required this.note,
    required this.createdTime,
    required this.photo,
  });

  ExpenseModel copyWith({
    int? id,
    String? title,
    int? number,
    String? type,
    String? note,
    DateTime? createdTime,
    String? photo,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      number: number ?? this.number,
      type: type ?? this.type,
      note: note ?? this.note,
      createdTime: createdTime ?? this.createdTime,
      photo: photo ?? this.photo,
    );
  }

  static ExpenseModel fromJson(Map<String, Object?> json) => ExpenseModel(
        id: json[ExpenseFields.id] as int?,
        title: json[ExpenseFields.title] as String,
        number: json[ExpenseFields.number] as int,
        type: json[ExpenseFields.type] as String,
        note: json[ExpenseFields.note] as String,
        createdTime: DateTime.parse(json[ExpenseFields.createdTime] as String),
        photo: json[ExpenseFields.photo] as String,
      );

  Map<String, Object?> toJson() => {
        ExpenseFields.id: id,
        ExpenseFields.title: title,
        ExpenseFields.number: number,
        ExpenseFields.type: type,
        ExpenseFields.note: note,
        ExpenseFields.createdTime: createdTime.toIso8601String(),
        ExpenseFields.photo: photo,
      };
}
