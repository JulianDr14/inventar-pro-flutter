import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/features/inventory/domain/entities/product.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:intentary_pro/features/inventory/domain/usecase/get_products_usecase.dart';

/// Un StateNotifier que carga productos y expone estado (loading, error, lista)
class SharedProductListState {
  final bool loading;
  final String? error;
  final List<Product> products;
  const SharedProductListState({
    this.loading = false,
    this.error,
    this.products = const [],
  });
  SharedProductListState copyWith({
    bool? loading,
    String? error,
    List<Product>? products,
  }) => SharedProductListState(
    loading: loading ?? this.loading,
    error:   error   ?? this.error,
    products: products ?? this.products,
  );
}

class SharedProductListNotifier
    extends StateNotifier<SharedProductListState> {
  final GetProductsUseCase _getProducts;
  SharedProductListNotifier(this._getProducts)
      : super(const SharedProductListState()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(loading: true);
    final Either<Failure, List<Product>> result =
    await _getProducts(NoParams());
    result.fold(
          (failure) => state = state.copyWith(
        loading: false,
        error: failure.message,
      ),
          (list) => state = state.copyWith(
        loading: false,
        products: list,
      ),
    );
  }
}