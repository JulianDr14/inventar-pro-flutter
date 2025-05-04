import 'package:intentary_pro/core/database/sqlite_database.dart';
import 'package:intentary_pro/features/inventory/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

/// Contrato para operaciones CRUD de productos en SQLite
abstract class ProductLocalDataSource {
  /// Devuelve todos los productos existentes
  Future<List<ProductModel>> getProducts();

  /// Inserta un nuevo producto y devuelve su ID generado
  Future<int> insertProduct(ProductModel product);

  /// Actualiza un producto existente
  Future<int> updateProduct(ProductModel product);

  /// Elimina un producto por su ID
  Future<int> deleteProduct(int id);
}

/// Implementación que usa el singleton SqliteDatabase
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SqliteDatabase _db;

  ProductLocalDataSourceImpl(this._db);

  @override
  Future<List<ProductModel>> getProducts() async {
    final Database db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      orderBy: 'name ASC',
    );
    return maps.map(ProductModel.fromMap).toList();
  }

  @override
  Future<int> insertProduct(ProductModel product) async {
    final db = await _db.database;
    return await db.insert('products', product.toMap());
  }

  @override
  Future<int> updateProduct(ProductModel product) async {
    final db = await _db.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  @override
  Future<int> deleteProduct(int id) async {
    final db = await _db.database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}