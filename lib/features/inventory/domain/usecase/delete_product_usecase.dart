import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/core/usecases/usecase.dart';
import 'package:intentary_pro/features/inventory/domain/repositories/inventory_repository.dart';

class DeleteProductParams {
  final int id;
  DeleteProductParams({required this.id});
}

class DeleteProductUseCase implements UseCase<void, DeleteProductParams> {
  final InventoryRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteProductParams params) {
    return repository.deleteProduct(params.id);
  }
}
