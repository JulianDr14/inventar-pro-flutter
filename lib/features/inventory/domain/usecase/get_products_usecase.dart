import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/core/usecases/usecase.dart';
import 'package:intentary_pro/features/inventory/domain/entities/product.dart';
import 'package:intentary_pro/features/inventory/domain/repositories/inventory_repository.dart';

class NoParams {}

class GetProductsUseCase implements UseCase<List<Product>, NoParams> {
  final InventoryRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) {
    return repository.getProducts();
  }
}