import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/features/inventory/domain/entities/product.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, void>> addProduct(String name, int quantity);
  Future<Either<Failure, void>> deleteProduct(int id);
  Future<Either<Failure, void>> updateProduct(int id, String name, int quantity);
}