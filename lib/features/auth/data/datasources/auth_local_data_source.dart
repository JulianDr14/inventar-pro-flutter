import 'package:intentary_pro/core/database/sqlite_database.dart';
import 'package:intentary_pro/features/auth/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getUser(String username, String password);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SqliteDatabase _db;

  AuthLocalDataSourceImpl(this._db);

  @override
  Future<UserModel?> getUser(String username, String password) async {
    final Database db = await _db.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }
}