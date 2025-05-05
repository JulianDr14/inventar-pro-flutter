import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/core/usecases/usecase.dart';
import 'package:intentary_pro/features/inventory/domain/repositories/inventory_repository.dart';

class AddProductParams {
  final String name;
  final int quantity;

  AddProductParams({required this.name, required this.quantity});
}

class AddProductUseCase implements UseCase<void, AddProductParams> {
  final InventoryRepository repository;

  AddProductUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddProductParams params) {
    return repository.addProduct(params.name, params.quantity);
  }
}
