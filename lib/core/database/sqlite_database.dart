import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteDatabase {
  static final SqliteDatabase _instance = SqliteDatabase._internal();
  factory SqliteDatabase() => _instance;
  SqliteDatabase._internal();

  static const String _dbName = 'app_database.db';
  static const int _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1) Tabla de usuarios
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.insert(
      'users',
      {'username': 'admin', 'password': 'admin123'},
    );

    await db.execute('''
      CREATE TABLE products (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        name        TEXT    NOT NULL UNIQUE,
        quantity    INTEGER NOT NULL DEFAULT 0,
        created_at  TEXT    NOT NULL DEFAULT (datetime('now')),
        updated_at  TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE inventory_movements (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id  INTEGER NOT NULL,
        type        TEXT    NOT NULL CHECK(type IN ('IN','OUT')),
        quantity    INTEGER NOT NULL,
        created_at  TEXT    NOT NULL DEFAULT (datetime('now')),
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');

    await db.execute('''
      CREATE TRIGGER trg_after_insert_movement
      AFTER INSERT ON inventory_movements
      BEGIN
        UPDATE products
        SET quantity = quantity
          + CASE WHEN NEW.type = 'IN' THEN NEW.quantity ELSE -NEW.quantity END
        WHERE id = NEW.product_id;
      END
    ''');

    await db.execute('''
      CREATE TRIGGER trg_after_update_product
      AFTER UPDATE ON products
      BEGIN
        UPDATE products
        SET updated_at = datetime('now')
        WHERE id = NEW.id;
      END
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
