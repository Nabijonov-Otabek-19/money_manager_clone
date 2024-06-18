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

    _database = await _initDB('notes.db');
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

    await db.execute('''
CREATE TABLE ${ExpenseFields.tableName} ( 
  ${ExpenseFields.id} $idType,
  ${ExpenseFields.title} $textType,
  ${ExpenseFields.icon} $textType,
  ${ExpenseFields.type} $textType,
  ${ExpenseFields.note} $textType,
  ${ExpenseFields.number} $numberType,
  ${ExpenseFields.createdTime} $textType,
  ${ExpenseFields.photo} $textType
  )
''');
  }

  Future<ExpenseModel> create(ExpenseModel note) async {
    final db = await instance.database;

    final id = await db.insert(ExpenseFields.tableName, note.toJson());
    return note.copyWith(id: id);
  }

  Future<ExpenseModel> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      ExpenseFields.tableName,
      columns: ExpenseFields.values,
      where: '${ExpenseFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ExpenseModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<ExpenseModel>> readAllNotes() async {
    final db = await instance.database;

    const orderBy = '${ExpenseFields.createdTime} DESC';
    final result = await db.query(ExpenseFields.tableName, orderBy: orderBy);

    return result.map((json) => ExpenseModel.fromJson(json)).toList();
  }

  Future<int> update(ExpenseModel note) async {
    final db = await instance.database;

    return db.update(
      ExpenseFields.tableName,
      note.toJson(),
      where: '${ExpenseFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      ExpenseFields.tableName,
      where: '${ExpenseFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
