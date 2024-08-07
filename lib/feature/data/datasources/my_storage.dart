import 'dart:async';

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/my_model.dart';
import '../../../core/utils/constants.dart';

class ExpenseStorage {
  static final ExpenseStorage instance = ExpenseStorage._init();

  static Database? _database;

  ExpenseStorage._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(ExpenseFields.dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const numberType = 'INTEGER NOT NULL';

    const yearTable = '''
    CREATE TABLE ${ExpenseFields.yearTableName} (
      id $idType,
      yearTime $textType
    )
    ''';

    const monthTable = '''
    CREATE TABLE ${ExpenseFields.monthTableName} (
      id $idType,
      monthTime $textType,
      yearId $numberType,
      FOREIGN KEY (yearId) REFERENCES years (id) ON DELETE CASCADE
    )
    ''';

    const dayTable = '''
    CREATE TABLE ${ExpenseFields.dayTableName} (
      id $idType,
      dayTime $textType,
      monthId $numberType,
      FOREIGN KEY (monthId) REFERENCES months (id) ON DELETE CASCADE
    )
    ''';

    const expenseTable = '''
    CREATE TABLE ${ExpenseFields.expenseTableName} (
      ${ExpenseFields.id} $idType,
      ${ExpenseFields.title} $textType,
      ${ExpenseFields.icon} $textType,
      ${ExpenseFields.number} $numberType,
      ${ExpenseFields.type} $textType,
      ${ExpenseFields.note} $textType,
      ${ExpenseFields.createdTime} $textType,
      ${ExpenseFields.photo} $textType,
      ${ExpenseFields.color} $numberType,
      ${ExpenseFields.dayId} $numberType,
      FOREIGN KEY (dayId) REFERENCES days (id) ON DELETE CASCADE
    )
    ''';

    await db.execute(yearTable);
    await db.execute(monthTable);
    await db.execute(dayTable);
    await db.execute(expenseTable);
  }

  Future<int> _createYear(YearModel year) async {
    final db = await instance.database;

    // Check if year exists
    final yearMap = await db.query(
      ExpenseFields.yearTableName,
      where: 'yearTime = ?',
      whereArgs: [year.yearTime.toIso8601String()],
    );

    if (yearMap.isNotEmpty) {
      return yearMap.first['id'] as int;
    }

    return await db.insert(ExpenseFields.yearTableName, year.toJson());
  }

  Future<int> _createMonth(MonthModel month, int yearId) async {
    final db = await instance.database;

    // Check if month exists
    final monthMap = await db.query(
      ExpenseFields.monthTableName,
      where: 'monthTime = ? AND yearId = ?',
      whereArgs: [month.monthTime.toIso8601String(), yearId],
    );

    if (monthMap.isNotEmpty) {
      return monthMap.first['id'] as int;
    }

    return await db.insert(ExpenseFields.monthTableName, month.toJson(yearId));
  }

  Future<int> _createDay(DayModel day, int monthId) async {
    final db = await instance.database;

    // Check if day exists
    final dayMap = await db.query(
      ExpenseFields.dayTableName,
      where: 'dayTime = ? AND monthId = ?',
      whereArgs: [day.dayTime.toIso8601String(), monthId],
    );

    if (dayMap.isNotEmpty) {
      return dayMap.first['id'] as int;
    }

    return await db.insert(ExpenseFields.dayTableName, day.toJson(monthId));
  }

  Future<int> _createExpense(ExpenseModel expense, int dayId) async {
    final db = await instance.database;

    return await db.insert(
      ExpenseFields.expenseTableName,
      expense.toJson(dayId),
    );
  }

  Future<void> addExpense(ExpenseModel expense) async {
    // Get current year
    final currentYear = DateTime(
      expense.createdTime.year,
    );

    // Get current month and day
    final currentMonth = DateTime(
      expense.createdTime.year,
      expense.createdTime.month,
    );

    final currentDay = DateTime(
      expense.createdTime.year,
      expense.createdTime.month,
      expense.createdTime.day,
    );

    // Create or get month
    int yearId = await _createYear(
      YearModel(
        yearTime: currentYear,
        listMonthModel: [],
      ),
    );

    // Create or get month
    int monthId = await _createMonth(
      MonthModel(
        monthTime: currentMonth,
        listDayModel: [],
      ),
      yearId,
    );

    // Create or get day
    int dayId = await _createDay(
      DayModel(
        dayTime: currentDay,
        listExpenseModel: [],
      ),
      monthId,
    );

    // Create expense
    await _createExpense(expense, dayId);
  }

  Future<List<DayModel>> getDaysByMonth(DateTime monthTime) async {
    final db = await instance.database;

    // Fetch the month by monthTime
    final monthMaps = await db.query(
      ExpenseFields.monthTableName,
      where: 'monthTime = ?',
      whereArgs: [monthTime.toIso8601String()],
    );

    if (monthMaps.isEmpty) return [];

    int monthId = monthMaps.first['id'] as int;
    List<DayModel> days = [];

    // Fetch all days for the given monthId
    const orderBy = 'dayTime DESC';
    final dayMaps = await db.query(
      ExpenseFields.dayTableName,
      where: 'monthId = ?',
      whereArgs: [monthId],
      orderBy: orderBy,
    );

    for (var dayMap in dayMaps) {
      int dayId = dayMap['id'] as int;
      List<ExpenseModel> expenses = [];

      // Fetch all expenses for the current day
      const orderBy = '${ExpenseFields.createdTime} DESC';
      final expenseMaps = await db.query(
        ExpenseFields.expenseTableName,
        where: 'dayId = ?',
        whereArgs: [dayId],
        orderBy: orderBy,
      );

      for (var expenseMap in expenseMaps) {
        expenses.add(ExpenseModel.fromJson(expenseMap));
      }

      days.add(DayModel.fromJson(dayMap, expenses));
    }

    return days;
  }

  Future<ExpenseModel?> getExpenseById(int id) async {
    final db = await instance.database;

    final expenseMaps = await db.query(
      ExpenseFields.expenseTableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (expenseMaps.isNotEmpty) {
      return ExpenseModel.fromJson(expenseMaps.first);
    } else {
      return null;
    }
  }

  Future<int> updateExpense(ExpenseModel expense) async {
    final db = await instance.database;

    // Get current year
    final currentYear = DateTime(
      expense.createdTime.year,
    );

    // Get current month and day
    final currentMonth = DateTime(
      expense.createdTime.year,
      expense.createdTime.month,
    );

    final currentDay = DateTime(
      expense.createdTime.year,
      expense.createdTime.month,
      expense.createdTime.day,
    );

    // Create or get month
    int yearId = await _createYear(
      YearModel(
        yearTime: currentYear,
        listMonthModel: [],
      ),
    );

    // Create or get month
    int monthId = await _createMonth(
      MonthModel(
        monthTime: currentMonth,
        listDayModel: [],
      ),
      yearId,
    );

    // Create or get day
    int dayId = await _createDay(
      DayModel(
        dayTime: currentDay,
        listExpenseModel: [],
      ),
      monthId,
    );

    return await db.update(
      ExpenseFields.expenseTableName,
      expense.toJson(dayId),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int modelId) async {
    final db = await instance.database;

    // Fetch the expense to get the dayId
    final expenseMap = await db.query(
      ExpenseFields.expenseTableName,
      where: 'id = ?',
      whereArgs: [modelId],
    );

    if (expenseMap.isNotEmpty) {
      final dayId = expenseMap.first['dayId'];

      // Delete the expense
      await db.delete(
        ExpenseFields.expenseTableName,
        where: 'id = ?',
        whereArgs: [modelId],
      );

      // Check if there are any more expenses for the day
      final remainingExpenses = await db.query(
        ExpenseFields.expenseTableName,
        where: 'dayId = ?',
        whereArgs: [dayId],
      );

      if (remainingExpenses.isEmpty) {
        // If no more expenses, delete the day
        await db.delete(
          ExpenseFields.dayTableName,
          where: 'id = ?',
          whereArgs: [dayId],
        );
      }
    }
    return 1;
  }

  Future<List<ExpenseModel>> searchByNote(String note, String type) async {
    final db = await instance.database;

    List<ExpenseModel> list = [];

    String query = type != "All".tr
        ? 'LOWER(note) LIKE ? AND ${ExpenseFields.type} = ?'
        : 'LOWER(note) LIKE ?';

    final args = type != "All".tr
        ? ['%${note.toLowerCase()}%', type]
        : ['%${note.toLowerCase()}%'];

    // Perform the search query
    final maps = await db.query(
      ExpenseFields.expenseTableName,
      where: query,
      whereArgs: args,
    );

    if (maps.isEmpty) return [];

    for (final map in maps) {
      list.add(ExpenseModel.fromJson(map));
    }
    return list;
  }

  Future<int> getCurrentMonthExpenses(DateTime monthTime) async {
    final db = await instance.database;

    List<ExpenseModel> expenses = [];

    // Fetch the month by monthTime
    final monthMaps = await db.query(
      ExpenseFields.monthTableName,
      where: 'monthTime = ?',
      whereArgs: [monthTime.toIso8601String()],
    );

    if (monthMaps.isEmpty) return 0;

    int monthId = monthMaps.first['id'] as int;

    // Fetch all days for the given monthId
    final dayMaps = await db.query(
      ExpenseFields.dayTableName,
      where: 'monthId = ?',
      whereArgs: [monthId],
    );

    for (var dayMap in dayMaps) {
      int dayId = dayMap['id'] as int;

      // Fetch all expenses for the current day
      final expenseMaps = await db.query(
        ExpenseFields.expenseTableName,
        where: 'dayId = ? AND ${ExpenseFields.type} = ?',
        whereArgs: [dayId, "Expense"],
      );

      for (var expenseMap in expenseMaps) {
        expenses.add(ExpenseModel.fromJson(expenseMap));
      }
    }

    final totalExpense = expenses.fold(0, (sum, model) => sum + model.number);
    return totalExpense;
  }

  Future<int> getCurrentMonthIncomes(DateTime monthTime) async {
    final db = await instance.database;

    List<ExpenseModel> incomes = [];

    // Fetch the month by monthTime
    final monthMaps = await db.query(
      ExpenseFields.monthTableName,
      where: 'monthTime = ?',
      whereArgs: [monthTime.toIso8601String()],
    );

    if (monthMaps.isEmpty) return 0;

    int monthId = monthMaps.first['id'] as int;

    // Fetch all days for the given monthId
    final dayMaps = await db.query(
      ExpenseFields.dayTableName,
      where: 'monthId = ?',
      whereArgs: [monthId],
    );

    for (var dayMap in dayMaps) {
      int dayId = dayMap['id'] as int;

      // Fetch all expenses for the current day
      final expenseMaps = await db.query(
        ExpenseFields.expenseTableName,
        where: 'dayId = ? AND ${ExpenseFields.type} = ?',
        whereArgs: [dayId, "Income"],
      );

      for (var expenseMap in expenseMaps) {
        incomes.add(ExpenseModel.fromJson(expenseMap));
      }
    }

    final totalIncome = incomes.fold(0, (sum, model) => sum + model.number);
    return totalIncome;
  }

  Future<List<ExpenseModel>> getModelsByType(
    String type,
    DateTime monthTime,
  ) async {
    final db = await instance.database;

    List<ExpenseModel> models = [];

    final currentYearTime = DateTime(DateTime.now().year);
    // Fetch the year by yearTime
    final yearMaps = await db.query(
      ExpenseFields.yearTableName,
      where: 'yearTime = ?',
      whereArgs: [currentYearTime.toIso8601String()],
    );

    if (yearMaps.isEmpty) return [];
    int yearId = yearMaps.first['id'] as int;

    // Fetch the month by monthTime
    final monthMaps = await db.query(
      ExpenseFields.monthTableName,
      where: 'monthTime = ? AND yearId = ?',
      whereArgs: [monthTime.toIso8601String(), yearId],
    );

    if (monthMaps.isEmpty) return [];

    int monthId = monthMaps.first['id'] as int;

    // Fetch all days for the given monthId
    final dayMaps = await db.query(
      ExpenseFields.dayTableName,
      where: 'monthId = ?',
      whereArgs: [monthId],
    );

    for (var dayMap in dayMaps) {
      int dayId = dayMap['id'] as int;

      // Fetch all expenses for the current day
      final expenseMaps = await db.query(
        ExpenseFields.expenseTableName,
        where: 'dayId = ? AND ${ExpenseFields.type} = ?',
        whereArgs: [dayId, type],
      );

      for (var expenseMap in expenseMaps) {
        models.add(ExpenseModel.fromJson(expenseMap));
      }
    }
    return models;
  }

  Future<List<ExpenseModel>> getMonthsByYearId(
    DateTime yearTime,
    String type,
  ) async {
    final db = await instance.database;

    List<ExpenseModel> totalNumber = [];

    // Fetch the year by yearTime
    final yearMaps = await db.query(
      ExpenseFields.yearTableName,
      where: 'yearTime = ?',
      whereArgs: [yearTime.toIso8601String()],
    );

    if (yearMaps.isEmpty) return [];

    int yearId = yearMaps.first['id'] as int;

    // Fetch all months for the given yearId
    final monthMaps = await db.query(
      ExpenseFields.monthTableName,
      where: 'yearId = ?',
      whereArgs: [yearId],
    );

    for (var monthMap in monthMaps) {
      int monthId = monthMap['id'] as int;

      // Fetch all days for the given monthId
      final dayMaps = await db.query(
        ExpenseFields.dayTableName,
        where: 'monthId = ?',
        whereArgs: [monthId],
      );

      for (var dayMap in dayMaps) {
        int dayId = dayMap['id'] as int;

        // Fetch all days for the given monthId
        final expenseMaps = await db.query(
          ExpenseFields.expenseTableName,
          where: 'dayId = ? AND ${ExpenseFields.type} = ?',
          whereArgs: [dayId, type],
        );

        for (var expenseMap in expenseMaps) {
          totalNumber.add(ExpenseModel.fromJson(expenseMap));
        }
      }
    }
    return totalNumber;
  }

  Future<void> clearAllData() async {
    final db = await instance.database;

    final tables = [
      ExpenseFields.yearTableName,
      ExpenseFields.monthTableName,
      ExpenseFields.dayTableName,
      ExpenseFields.expenseTableName,
    ];

    for (var table in tables) {
      await db.delete(table);
    }
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
