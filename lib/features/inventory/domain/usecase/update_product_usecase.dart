import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/core/usecases/usecase.dart';
import 'package:intentary_pro/features/inventory/domain/repositories/inventory_repository.dart';

class UpgradeProductParams{
  final int id;
  final String name;
  final int quantity;

  UpgradeProductParams({
    required this.id,
    required this.name,
    required this.quantity,
  });
}

class UpgradeProductUsecase implements UseCase<void, UpgradeProductParams>{
  final InventoryRepository repository;

  UpgradeProductUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpgradeProductParams params) {
    return repository.updateProduct(params.id, params.name, params.quantity);
  }
}