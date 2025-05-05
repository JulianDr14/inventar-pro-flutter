import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/core/usecases/usecase.dart';
import 'package:intentary_pro/features/movements/domain/entities/inventory_movement.dart';
import 'package:intentary_pro/features/movements/domain/repositories/inventory_movement_repository.dart';

class NoParams {}

class GetMovementsUseCase
    implements UseCase<List<InventoryMovement>, NoParams> {
  final InventoryMovementRepository repository;

  GetMovementsUseCase(this.repository);

  @override
  Future<Either<Failure, List<InventoryMovement>>> call(NoParams params) async {
    return await repository.getMovements();
  }
}
