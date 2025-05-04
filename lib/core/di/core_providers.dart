import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/core/database/sqlite_database.dart';

final sqliteDbProvider = Provider<SqliteDatabase>((ref) {
  return SqliteDatabase();
});
