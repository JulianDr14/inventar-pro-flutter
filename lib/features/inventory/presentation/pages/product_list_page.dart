import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/core/services/snackbar_service.dart';
import 'package:intentary_pro/features/inventory/di/inventory_providers.dart';
import 'package:intentary_pro/features/inventory/domain/entities/product.dart';
import 'package:intentary_pro/features/inventory/presentation/dialogs/confirm_delete_dialog.dart';
import 'package:intentary_pro/features/inventory/presentation/widgets/product_form.dart.dart';
import 'package:intentary_pro/features/inventory/presentation/widgets/product_list_content.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showProductForm({Product? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: ProductForm(
          product: product,
          onSave: ({id, required name, required quantity}) {
            final notifier = ref.read(productListViewModelProvider.notifier);
            if (id == null) {
              return notifier.addProduct(name: name, quantity: quantity);
            } else {
              return notifier.upgradeProduct(id, name, quantity);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
      ),
      body: ProductListContent(
        searchQuery: _searchCtrl.text,
        onEdit: (id) {
          final product = ref
              .read(productListViewModelProvider)
              .products
              .firstWhere((p) => p.id == id);
          _showProductForm(product: product);
        },
        onDelete: (id) async {
          final shouldDelete = await ConfirmDeleteDialog.show(context);
          if (shouldDelete == true) {
            await ref
                .read(productListViewModelProvider.notifier)
                .deleteProduct(id);

            if(!context.mounted) return;

            SnackbarService.show(
              context,
              message: 'Producto eliminado',
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
