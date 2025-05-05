import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/core/di/core_providers.dart';
import 'package:intentary_pro/core/di/shared_providers.dart';
import 'package:intentary_pro/core/services/snackbar_service.dart';
import 'package:intentary_pro/features/inventory/di/inventory_providers.dart';
import 'package:intentary_pro/features/inventory/domain/entities/product.dart';
import 'package:intentary_pro/features/inventory/presentation/dialogs/confirm_delete_dialog.dart';
import 'package:intentary_pro/features/inventory/presentation/viewmodel/product_list_viewmodel.dart';
import 'package:intentary_pro/features/inventory/presentation/widgets/product_form.dart';
import 'package:intentary_pro/features/inventory/presentation/widgets/product_list_content.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    final SharedProductListState sharedState = ref.watch(sharedProductListProvider);
    final ProductListViewModel viewModel = ref.read(productListViewModelProvider);

    void openForm({Product? product}) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: ProductForm(
            product: product,
            onSave: ({int? id, required String name, required int quantity}) {
              if (id == null) {
                return viewModel.addProduct(name: name, quantity: quantity);
              } else {
                return viewModel.updateProduct(
                  id: id,
                  name: name,
                  quantity: quantity,
                );
              }
            },
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar producto...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (q) =>
                ref.read(searchQueryProvider.notifier).state = q,
              ),
            ),
            Expanded(
              child: ProductListContent(
                onEdit: (id) {
                  final product = sharedState.products
                      .firstWhere((p) => p.id == id);
                  openForm(product: product);
                },
                onDelete: (id, fromMenu) async {
                  bool ok = true;
                  if (fromMenu) {
                    ok = await ConfirmDeleteDialog.show(context) ?? false;
                  }
                  if (!ok) return;
                  await viewModel.deleteProduct(id);
                  if (!context.mounted) return;
                  SnackbarService.show(
                    context,
                    message: 'Producto eliminado',
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_product_hero',
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
