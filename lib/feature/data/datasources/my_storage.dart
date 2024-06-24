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
    CREATE TABLE months (
      id $idType,
      monthTime $textType
    )
    ''';

    const dayTable = '''
    CREATE TABLE days (
      id $idType,
      dayTime $textType,
      monthId $numberType,
      FOREIGN KEY (monthId) REFERENCES months (id) ON DELETE CASCADE
    )
    ''';

    const expenseTable = '''
    CREATE TABLE ${ExpenseFields.tableName} (
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

  Future<int> createMonth(MonthModel month) async {
    final db = await instance.database;

    // Check if month exists
    final monthMap = await db.query(
      'months',
      where: 'monthTime = ?',
      whereArgs: [month.monthTime.toIso8601String()],
    );

    if (monthMap.isNotEmpty) {
      return monthMap.first['id'] as int;
    }

    return await db.insert('months', month.toJson());
  }

  Future<int> createDay(DayModel day, int monthId) async {
    final db = await instance.database;

    // Check if day exists
    final dayMap = await db.query(
      'days',
      where: 'dayTime = ? AND monthId = ?',
      whereArgs: [day.dayTime.toIso8601String(), monthId],
    );

    if (dayMap.isNotEmpty) {
      return dayMap.first['id'] as int;
    }

    return await db.insert('days', day.toJson(monthId));
  }

  Future<int> createExpense(ExpenseModel expense, int dayId) async {
    final db = await instance.database;
    return await db.insert(ExpenseFields.tableName, expense.toJson(dayId));
  }

  Future<void> addExpense(ExpenseModel expense) async {
    //final db = await instance.database;

    // Get current month and day
    final currentMonth =
        DateTime(expense.createdTime.year, expense.createdTime.month);
    final currentDay = DateTime(expense.createdTime.year,
        expense.createdTime.month, expense.createdTime.day);

    // Create or get month
    int monthId = await createMonth(
        MonthModel(monthTime: currentMonth, listDayModel: []));

    // Create or get day
    int dayId = await createDay(
        DayModel(dayTime: currentDay, listExpenseModel: []), monthId);

    // Create expense
    await createExpense(expense, dayId);
  }

  Future<List<MonthModel>> getAllExpenses() async {
    final db = await instance.database;

    // Fetch all months
    final monthMaps = await db.query('months');

    List<MonthModel> months = [];

    for (var monthMap in monthMaps) {
      int monthId = monthMap['id'] as int;
      List<DayModel> days = [];

      // Fetch all days for the current month
      final dayMaps = await db.query(
        'days',
        where: 'monthId = ?',
        whereArgs: [monthId],
      );

      for (var dayMap in dayMaps) {
        int dayId = dayMap['id'] as int;
        List<ExpenseModel> expenses = [];

        // Fetch all expenses for the current day
        const orderBy = '${ExpenseFields.createdTime} DESC';
        final expenseMaps = await db.query(
          ExpenseFields.tableName,
          where: 'dayId = ?',
          whereArgs: [dayId],
          orderBy: orderBy,
        );

        for (var expenseMap in expenseMaps) {
          expenses.add(ExpenseModel.fromJson(expenseMap));
        }

        days.add(DayModel.fromJson(dayMap, expenses));
      }

      months.add(MonthModel.fromJson(monthMap, days));
    }

    return months;
  }

  Future<ExpenseModel?> getExpenseById(int id) async {
    final db = await instance.database;

    final expenseMaps = await db.query(
      ExpenseFields.tableName,
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

    return await db.update(
      ExpenseFields.tableName,
      expense.toJson(expense.id!), // Make sure expense.id is not null
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await instance.database;

    return await db.delete(
      ExpenseFields.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getCurrentMonthExpenses() async {
    final db = await instance.database;

    final maps = await db.query(
      ExpenseFields.tableName,
      columns: ExpenseFields.values,
      where: '${ExpenseFields.type} = ?',
      whereArgs: ["Expense"],
    );

    final list = maps.map((model) => ExpenseModel.fromJson(model)).toList();
    final totalExpense = list.fold(0, (sum, model) => sum + model.number);

    return totalExpense;
  }

  Future<int> getCurrentMonthIncomes() async {
    final db = await instance.database;

    final maps = await db.query(
      ExpenseFields.tableName,
      columns: ExpenseFields.values,
      where: '${ExpenseFields.type} = ?',
      whereArgs: ["Income"],
    );

    final list = maps.map((model) => ExpenseModel.fromJson(model)).toList();
    final totalIncome = list.fold(0, (sum, model) => sum + model.number);

    return totalIncome;
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
