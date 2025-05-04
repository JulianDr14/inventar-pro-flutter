import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/features/inventory/domain/entities/product.dart';
import 'package:intentary_pro/features/inventory/domain/usecase/add_product_usecase.dart';
import 'package:intentary_pro/features/inventory/domain/usecase/delete_product_usecase.dart';
import 'package:intentary_pro/features/inventory/domain/usecase/get_products_usecase.dart';
import 'package:intentary_pro/features/inventory/domain/usecase/update_product_usecase.dart';

class ProductListState {
  final bool loading;
  final String? error;
  final List<Product> products;

  const ProductListState({
    this.loading = false,
    this.error,
    this.products = const [],
  });

  ProductListState copyWith({
    bool? loading,
    String? error,
    List<Product>? products,
  }) {
    return ProductListState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      products: products ?? this.products,
    );
  }
}

class ProductListViewModel extends StateNotifier<ProductListState> {
  final GetProductsUseCase _getProducts;
  final AddProductUseCase _addProduct;
  final UpgradeProductUsecase _upgradeProduct;
  final DeleteProductUseCase _deleteProduct;

  ProductListViewModel(
      this._getProducts,
      this._addProduct,
      this._upgradeProduct,
      this._deleteProduct,
      ) : super(const ProductListState()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(loading: true);
    final result = await _getProducts(NoParams());
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

  Future<void> addProduct({required String name, required int quantity}) async {
    state = state.copyWith(loading: true);
    final result = await _addProduct(AddProductParams(
      name: name,
      quantity: quantity,
    ));
    result.fold(
          (failure) => state = state.copyWith(
        loading: false,
        error: failure.message,
      ),
          (_) async {
        await loadProducts();
      },
    );
  }

  Future<void> upgradeProduct(int id, String name, int quantity) async {
    state = state.copyWith(loading: true);
    final result = await _upgradeProduct(UpgradeProductParams(
      id: id,
      name: name,
      quantity: quantity,
    ));
    result.fold(
          (failure) => state = state.copyWith(
        loading: false,
        error: failure.message,
      ),
          (_) async {
        await loadProducts();
      },
    );
  }

  Future<void> deleteProduct(int id) async {
    state = state.copyWith(loading: true);
    final result = await _deleteProduct(DeleteProductParams(id: id));
    result.fold(
          (failure) => state = state.copyWith(
        loading: false,
        error: failure.message,
      ),
          (_) async {
        await loadProducts();
      },
    );
  }
}
