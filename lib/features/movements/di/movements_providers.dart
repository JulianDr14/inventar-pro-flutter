import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/core/di/core_providers.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/features/inventory/di/inventory_providers.dart';
import 'package:intentary_pro/features/inventory/domain/entities/product.dart';
import 'package:intentary_pro/features/inventory/domain/usecase/get_products_usecase.dart' as inventory;
import 'package:intentary_pro/features/movements/data/datasources/movements_local_data_source.dart';
import 'package:intentary_pro/features/movements/data/repositories/movements_repository_impl.dart';
import 'package:intentary_pro/features/movements/domain/repositories/inventory_movement_repository.dart';
import 'package:intentary_pro/features/movements/domain/usecase/add_movement_usecase.dart';
import 'package:intentary_pro/features/movements/domain/usecase/get_movement_usecase.dart';
import 'package:intentary_pro/features/movements/presentation/viewmodel/movement_list_view_model.dart';

/// 1. DataSource
final movementsLocalDataSourceProvider = Provider<MovementsLocalDataSource>((
  ref,
) {
  final db = ref.read(sqliteDbProvider);
  return MovementsLocalDataSourceImpl(db);
});

/// 2. Repository
final inventoryMovementRepositoryProvider =
    Provider<InventoryMovementRepository>((ref) {
      final localDs = ref.read(movementsLocalDataSourceProvider);
      return MovementRepositoryImpl(localDataSource: localDs);
    });

/// 3. UseCases
final getMovementsUseCaseProvider = Provider<GetMovementsUseCase>((ref) {
  final repo = ref.read(inventoryMovementRepositoryProvider);
  return GetMovementsUseCase(repo);
});

final addMovementUseCaseProvider = Provider<AddMovementUseCase>((ref) {
  final repo = ref.read(inventoryMovementRepositoryProvider);
  return AddMovementUseCase(repo);
});

/// 4. ViewModel (StateNotifier)
final movementListViewModelProvider =
    StateNotifierProvider<MovementListViewModel, MovementListState>((ref) {
      final getMovements = ref.read(getMovementsUseCaseProvider);
      final addMovement = ref.read(addMovementUseCaseProvider);
      return MovementListViewModel(getMovements, addMovement);
    });

final movementProductsProvider = FutureProvider<List<Product>>((ref) async {
  final inventory.GetProductsUseCase loadProducts = ref.read(getProductsUseCaseProvider);
  final Either<Failure, List<Product>> result = await loadProducts(inventory.NoParams());
  return result.fold(
        (failure) => throw Exception(failure.message),
        (list)    => list,
  );
});