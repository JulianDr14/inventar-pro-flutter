import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/features/inventory/data/datasources/product_local_data_source.dart';
import 'package:intentary_pro/features/inventory/data/models/product_model.dart';
import 'package:intentary_pro/features/inventory/domain/entities/product.dart';
import 'package:intentary_pro/features/inventory/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final ProductLocalDataSource localDataSource;

  InventoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final List<ProductModel> models = await localDataSource.getProducts();
      final List<Product> entities = models.map((m) => Product(
        id: m.id!,
        name: m.name,
        quantity: m.quantity,
        createdAt: m.createdAt!,
        updatedAt: m.updatedAt,
      )).toList();
      return Right(entities);
    } catch (_) {
      return Left(LocalFailure('Error al cargar productos'));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(String name, int quantity) async {
    try {
      final DateTime now = DateTime.now();
      final ProductModel model = ProductModel(
        name: name,
        quantity: quantity,
        createdAt: now,
        updatedAt: now,
      );
      await localDataSource.insertProduct(model);
      return const Right(null);
    } catch (_) {
      return Left(LocalFailure('Error al agregar producto'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    try {
      await localDataSource.deleteProduct(id);
      return const Right(null);
    } catch (_) {
      return Left(LocalFailure('Error al eliminar producto'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(int id, String name, int quantity) async {
    try{
      final DateTime now = DateTime.now();
      final ProductModel model = ProductModel(
        id: id,
        name: name,
        quantity: quantity,
        updatedAt: now,
      );
      await localDataSource.updateProduct(model);
      return const Right(null);
    } catch (_) {
      return Left(LocalFailure('Error al actualizar producto'));
    }
  }
}