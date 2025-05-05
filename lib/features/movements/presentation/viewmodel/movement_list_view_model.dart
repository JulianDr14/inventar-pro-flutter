import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/features/movements/domain/entities/inventory_movement.dart';
import 'package:intentary_pro/features/movements/domain/usecase/add_movement_usecase.dart';
import 'package:intentary_pro/features/movements/domain/usecase/get_movement_usecase.dart';

class MovementListState {
  final bool loading;
  final String? error;
  final List<InventoryMovement> movements;

  const MovementListState({
    this.loading = false,
    this.error,
    this.movements = const [],
  });

  MovementListState copyWith({
    bool? loading,
    String? error,
    List<InventoryMovement>? movements,
  }) {
    return MovementListState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      movements: movements ?? this.movements,
    );
  }
}

class MovementListViewModel extends StateNotifier<MovementListState> {
  final GetMovementsUseCase _getMovements;
  final AddMovementUseCase _addMovement;

  MovementListViewModel(this._getMovements, this._addMovement)
    : super(const MovementListState()) {
    loadMovements();
  }

  Future<void> loadMovements() async {
    state = state.copyWith(loading: true);
    final result = await _getMovements(NoParams());
    result.fold(
      (f) => state = state.copyWith(loading: false, error: f.message),
      (list) => state = state.copyWith(loading: false, movements: list),
    );
  }

  Future<void> addMovement(InventoryMovement mv) async {
    state = state.copyWith(loading: true);
    final result = await _addMovement(
      AddMovementParams(
        productId: mv.productId,
        type: mv.type,
        quantity: mv.quantity,
      ),
    );
    await result.fold(
      (f) async {
        state = state.copyWith(loading: false, error: f.message);
      },
      (_) async {
        await loadMovements();
        state = state.copyWith(loading: false);
      },
    );
  }
}
