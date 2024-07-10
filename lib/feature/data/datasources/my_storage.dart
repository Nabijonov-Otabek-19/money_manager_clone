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

    _database = await _initDB('expenses.db');
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

    const monthTable = '''
    CREATE TABLE ${ExpenseFields.monthTableName} (
      id $idType,
      monthTime $textType
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
      ${ExpenseFields.dayId} $numberType,
      FOREIGN KEY (dayId) REFERENCES days (id) ON DELETE CASCADE
    )
    ''';

    await db.execute(monthTable);
    await db.execute(dayTable);
    await db.execute(expenseTable);
  }

  Future<int> _createMonth(MonthModel month) async {
    final db = await instance.database;

    // Check if month exists
    final monthMap = await db.query(
      ExpenseFields.monthTableName,
      where: 'monthTime = ?',
      whereArgs: [month.monthTime.toIso8601String()],
    );

    if (monthMap.isNotEmpty) {
      return monthMap.first['id'] as int;
    }

    return await db.insert(ExpenseFields.monthTableName, month.toJson());
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
    int monthId = await _createMonth(
      MonthModel(
        monthTime: currentMonth,
        listDayModel: [],
      ),
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
    int monthId = await _createMonth(
      MonthModel(
        monthTime: currentMonth,
        listDayModel: [],
      ),
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

  Future<int> deleteExpense(int id) async {
    final db = await instance.database;

    // Fetch the expense to get the dayId
    final expenseMap = await db.query(
      ExpenseFields.expenseTableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (expenseMap.isNotEmpty) {
      final dayId = expenseMap.first['dayId'];

      // Delete the expense
      await db.delete(
        ExpenseFields.expenseTableName,
        where: 'id = ?',
        whereArgs: [id],
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

  Future<List<ExpenseModel>> searchByNote(String note) async {
    final db = await instance.database;

    List<ExpenseModel> list = [];

    // Perform the search query
    final maps = await db.query(
      ExpenseFields.expenseTableName,
      where: 'LOWER(note) LIKE ?',
      whereArgs: ['%${note.toLowerCase()}%'],
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
      String type, DateTime monthTime) async {
    final db = await instance.database;

    List<ExpenseModel> models = [];

    // Fetch the month by monthTime
    final monthMaps = await db.query(
      ExpenseFields.monthTableName,
      where: 'monthTime = ?',
      whereArgs: [monthTime.toIso8601String()],
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

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
