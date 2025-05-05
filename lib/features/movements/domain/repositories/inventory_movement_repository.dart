import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/features/movements/domain/entities/inventory_movement.dart';

abstract class InventoryMovementRepository {
  Future<Either<Failure, void>> addMovement(InventoryMovement movement);

  Future<Either<Failure, List<InventoryMovement>>> getMovements();
}
