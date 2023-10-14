import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // TODO
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workouts(

      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getWorkouts() async {
    final db = await database;
    return db.query('workouts');
  }
}
