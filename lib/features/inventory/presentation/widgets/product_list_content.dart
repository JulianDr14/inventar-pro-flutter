import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/features/inventory/di/inventory_providers.dart';
import 'package:intentary_pro/features/inventory/domain/entities/product.dart';
import 'package:intentary_pro/features/inventory/presentation/dialogs/confirm_delete_dialog.dart';
import 'package:intentary_pro/features/inventory/presentation/viewmodel/product_list_viewmodel.dart';

class ProductListContent extends ConsumerWidget {
  final String searchQuery;
  final void Function(int) onEdit;
  final void Function(int, bool) onDelete;

  const ProductListContent({
    required this.searchQuery,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  Widget backgroundDismissible(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16),
      color: Colors.red.withValues(alpha: 0.2),
      child: const Icon(Icons.delete, color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProductListState state = ref.watch(productListViewModelProvider);
    final List<Product> products = state.products
        .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(child: Text(state.error!));
    }
    if (products.isEmpty) {
      return const Center(child: Text('No se encontraron productos'));
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (_, i) {
        final p = products[i];
        return Dismissible(
          key: ValueKey(p.id),
          confirmDismiss: (direction) async {
            final bool? shouldDelete = await ConfirmDeleteDialog.show(context);

            if (shouldDelete == true) {
              onDelete(p.id, false);
              return true;
            }
            return false;
          },
          background: backgroundDismissible(context),
          secondaryBackground: backgroundDismissible(context),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              child: Text(
                '${p.quantity}',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            title: Text(p.name),
            subtitle: Text('ID: ${p.id}'),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit(p.id);
                } else if (value == 'delete') {
                  onDelete(p.id, true);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    Icon(Icons.create_outlined, size: 16),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ]),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete_outline_rounded,
                        size: 16, color: Colors.red),
                    Text('Eliminar', style: TextStyle(color: Colors.red)),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}