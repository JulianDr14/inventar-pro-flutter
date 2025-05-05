import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/core/di/core_providers.dart';
import 'package:intentary_pro/features/inventory/domain/usecase/add_product_usecase.dart';
import 'package:intentary_pro/features/inventory/domain/usecase/update_product_usecase.dart';
import 'package:intentary_pro/features/inventory/domain/usecase/delete_product_usecase.dart';

class ProductListViewModel {
  final AddProductUseCase _add;
  final UpgradeProductUsecase _update;
  final DeleteProductUseCase _delete;
  final Ref _ref;

  ProductListViewModel(
      this._add,
      this._update,
      this._delete,
      this._ref,
      );

  Future<void> addProduct({ required String name, required int quantity }) async {
    final result = await _add(AddProductParams(name: name, quantity: quantity));
    result.fold(
          (f) => throw Exception(f.message),
          (_) => _ref.read(sharedProductListProvider.notifier).loadProducts(),
    );
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required int quantity,
  }) async {
    final result = await _update(UpgradeProductParams(
      id: id, name: name, quantity: quantity,
    ));
    result.fold(
          (f) => throw Exception(f.message),
          (_) => _ref.read(sharedProductListProvider.notifier).loadProducts(),
    );
  }

  Future<void> deleteProduct(int id) async {
    final result = await _delete(DeleteProductParams(id: id));
    result.fold(
          (f) => throw Exception(f.message),
          (_) => _ref.read(sharedProductListProvider.notifier).loadProducts(),
    );
  }
}
