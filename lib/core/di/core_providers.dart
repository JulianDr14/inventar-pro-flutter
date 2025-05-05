import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/core/database/sqlite_database.dart';
import 'package:intentary_pro/core/di/shared_providers.dart';
import 'package:intentary_pro/features/inventory/di/inventory_providers.dart';

final sqliteDbProvider = Provider<SqliteDatabase>((ref) {
  return SqliteDatabase();
});

/// Provider compartido para la lista de productos
final sharedProductListProvider = StateNotifierProvider<
    SharedProductListNotifier,
    SharedProductListState
>((ref) {
  final getProducts = ref.read(getProductsUseCaseProvider);
  return SharedProductListNotifier(getProducts);
});