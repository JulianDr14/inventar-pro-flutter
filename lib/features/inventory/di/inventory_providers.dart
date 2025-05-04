import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/core/di/core_providers.dart';
import 'package:intentary_pro/features/inventory/data/datasources/product_local_data_source.dart';
import 'package:intentary_pro/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:intentary_pro/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:intentary_pro/features/inventory/domain/usecase/add_product_usecase.dart';
import 'package:intentary_pro/features/inventory/domain/usecase/delete_product_usecase.dart';
import 'package:intentary_pro/features/inventory/domain/usecase/get_products_usecase.dart';
import 'package:intentary_pro/features/inventory/domain/usecase/update_product_usecase.dart';
import 'package:intentary_pro/features/inventory/presentation/viewmodel/product_list_viewmodel.dart';

final productLocalDataSourceProvider = Provider<ProductLocalDataSource>((ref) {
  final db = ref.read(sqliteDbProvider);
  return ProductLocalDataSourceImpl(db);
});

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final localDS = ref.read(productLocalDataSourceProvider);
  return InventoryRepositoryImpl(localDataSource: localDS);
});

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repo = ref.read(inventoryRepositoryProvider);
  return GetProductsUseCase(repo);
});

final addProductUseCaseProvider = Provider<AddProductUseCase>((ref) {
  final repo = ref.read(inventoryRepositoryProvider);
  return AddProductUseCase(repo);
});

final deleteProductUseCaseProvider = Provider<DeleteProductUseCase>((ref) {
  final repo = ref.read(inventoryRepositoryProvider);
  return DeleteProductUseCase(repo);
});

final upgradeProductUseCaseProvider = Provider<UpgradeProductUsecase>((ref) {
  final repo = ref.read(inventoryRepositoryProvider);
  return UpgradeProductUsecase(repo);
});

final productListViewModelProvider =
StateNotifierProvider<ProductListViewModel, ProductListState>((ref) {
  final getProducts = ref.read(getProductsUseCaseProvider);
  final addProduct = ref.read(addProductUseCaseProvider);
  final upgradeProduct = ref.read(upgradeProductUseCaseProvider);
  final deleteProduct = ref.read(deleteProductUseCaseProvider);
  return ProductListViewModel(
    getProducts,
    addProduct,
    upgradeProduct,
    deleteProduct,
  );
});
