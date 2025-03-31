import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> deleteDatabaseFile() async {
  final path = join(await getDatabasesPath(), 'app_database.db');
  await deleteDatabase(path);
  print('Database deleted.');
}

  Future<void> _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE recipes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT,
      ingredients TEXT,
      instructions TEXT,
      is_favorite INTEGER DEFAULT 0
    )
  ''');
}

Future<void> insertRecipe(Map<String, dynamic> recipe) async {
  final db = await database;
  await db.insert('recipes', recipe);
}

Future<List<Map<String, dynamic>>> getRecipes() async {
  final db = await database;
  return await db.query('recipes');
}
Future<void> toggleFavorite(int id, bool currentStatus) async {
  final db = await database;
  int newStatus = currentStatus ? 0 : 1;
  await db.update(
    'recipes',
    {'is_favorite': newStatus},
    where: 'id = ?',
    whereArgs: [id],
  );
}
}



  
