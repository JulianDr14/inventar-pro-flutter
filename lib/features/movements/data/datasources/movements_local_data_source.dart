import 'package:intentary_pro/core/database/sqlite_database.dart';
import 'package:intentary_pro/features/movements/data/models/inventary_movement_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class MovementsLocalDataSource {
  Future<List<MovementModel>> getMovements();

  Future<int> addMovement(MovementModel movement);
}

class MovementsLocalDataSourceImpl implements MovementsLocalDataSource {
  final SqliteDatabase _db;

  MovementsLocalDataSourceImpl(this._db);

  @override
  Future<int> addMovement(MovementModel model) async {
    final Database db = await _db.database;
    await db.insert('inventory_movements', model.toMap());
    return model.id ?? 0;
  }

  @override
  Future<List<MovementModel>> getMovements() async {
    final Database db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        im.id,
        im.product_id,
        p.name       AS name_product,
        im.type,
        im.quantity,
        im.created_at
      FROM inventory_movements AS im
      JOIN products             AS p
        ON im.product_id = p.id
      ORDER BY im.created_at DESC
    ''');
    return maps.map((m) => MovementModel.fromMap(m)).toList();
  }
}
