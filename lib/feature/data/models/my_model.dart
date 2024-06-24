import '../../../core/utils/constants.dart';

class MonthModel {
  final int? id;
  final DateTime monthTime;
  final List<DayModel> listDayModel;

  const MonthModel({
    this.id,
    required this.monthTime,
    required this.listDayModel,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monthTime': monthTime.toIso8601String(),
    };
  }

  static MonthModel fromJson(
    Map<String, dynamic> json,
    List<DayModel> listModel,
  ) {
    return MonthModel(
      id: json['id'],
      monthTime: DateTime.parse(json['monthTime']),
      listDayModel: listModel,
    );
  }
}

class DayModel {
  final int? id;
  final DateTime dayTime;
  final List<ExpenseModel> listExpenseModel;

  const DayModel({
    this.id,
    required this.dayTime,
    required this.listExpenseModel,
  });

  Map<String, dynamic> toJson(int monthId) {
    return {
      'id': id,
      'dayTime': dayTime.toIso8601String(),
      'monthId': monthId,
    };
  }

  static DayModel fromJson(
    Map<String, dynamic> json,
    List<ExpenseModel> listModel,
  ) {
    return DayModel(
      id: json['id'],
      dayTime: DateTime.parse(json['dayTime']),
      listExpenseModel: listModel,
    );
  }
}

class ExpenseModel {
  final int? id;
  final String title;
  final String icon;
  final int number;
  final String type;
  final String note;
  final DateTime createdTime;
  final String? photo;

  const ExpenseModel({
    this.id,
    required this.title,
    required this.icon,
    required this.number,
    required this.type,
    required this.note,
    required this.createdTime,
    required this.photo,
  });

  ExpenseModel copyWith({
    int? id,
    String? title,
    String? icon,
    int? number,
    String? type,
    String? note,
    DateTime? createdTime,
    String? photo,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      number: number ?? this.number,
      type: type ?? this.type,
      note: note ?? this.note,
      createdTime: createdTime ?? this.createdTime,
      photo: photo ?? this.photo,
    );
  }

  static ExpenseModel fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json[ExpenseFields.id],
      title: json[ExpenseFields.title],
      icon: json[ExpenseFields.icon],
      number: json[ExpenseFields.number],
      type: json[ExpenseFields.type],
      note: json[ExpenseFields.note],
      createdTime: DateTime.parse(json[ExpenseFields.createdTime]),
      photo: json[ExpenseFields.photo],
    );
  }

  Map<String, dynamic> toJson(int dayId) {
    return {
      ExpenseFields.id: id,
      ExpenseFields.title: title,
      ExpenseFields.icon: icon,
      ExpenseFields.number: number,
      ExpenseFields.type: type,
      ExpenseFields.note: note,
      ExpenseFields.createdTime: createdTime.toIso8601String(),
      ExpenseFields.photo: photo,
      ExpenseFields.dayId: dayId,
    };
  }
}
