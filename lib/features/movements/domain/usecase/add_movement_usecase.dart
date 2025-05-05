import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/core/usecases/usecase.dart';
import 'package:intentary_pro/features/movements/domain/entities/inventory_movement.dart';
import 'package:intentary_pro/features/movements/domain/repositories/inventory_movement_repository.dart';

class AddMovementParams {
  final int productId;
  final MovementType type;
  final int quantity;

  AddMovementParams({
    required this.productId,
    required this.type,
    required this.quantity,
  });
}

class AddMovementUseCase implements UseCase<void, AddMovementParams> {
  final InventoryMovementRepository repository;

  AddMovementUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddMovementParams params) async {
    final InventoryMovement movement = InventoryMovement(
      productId: params.productId,
      type: params.type,
      quantity: params.quantity,
      createdAt: DateTime.now(),
    );

    return await repository.addMovement(movement);
  }
}
