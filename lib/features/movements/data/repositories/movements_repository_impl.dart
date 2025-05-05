import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/features/movements/data/datasources/movements_local_data_source.dart';
import 'package:intentary_pro/features/movements/data/models/inventary_movement_model.dart';
import 'package:intentary_pro/features/movements/domain/entities/inventory_movement.dart';
import 'package:intentary_pro/features/movements/domain/repositories/inventory_movement_repository.dart';

class MovementRepositoryImpl implements InventoryMovementRepository {
  final MovementsLocalDataSource localDataSource;

  MovementRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> addMovement(InventoryMovement movement) async {
    try {
      final DateTime now = DateTime.now();
      final MovementModel model = MovementModel(
        productId: movement.productId,
        type: movement.type.toSqlValue(),
        quantity: movement.quantity,
        createdAt: now,
      );
      await localDataSource.addMovement(model);
      return const Right(null);
    } catch (_) {
      return Left(LocalFailure('Error al agregar movimiento'));
    }
  }

  @override
  Future<Either<Failure, List<InventoryMovement>>> getMovements() async {
    try {
      final List<MovementModel> models = await localDataSource.getMovements();
      final List<InventoryMovement> movements =
          models
              .map(
                (m) => InventoryMovement(
                  id: m.id,
                  productId: m.productId,
                  productName: m.nameProduct,
                  type: MovementTypeX.fromSqlValue(m.type),
                  quantity: m.quantity,
                  createdAt: m.createdAt,
                ),
              )
              .toList();
      return Right(movements);
    } catch (_) {
      return Left(LocalFailure('Error al obtener movimientos'));
    }
  }
}
