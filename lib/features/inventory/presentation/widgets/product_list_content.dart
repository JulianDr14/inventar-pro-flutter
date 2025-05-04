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
    final List<Product> products =
        state.products
            .where(
              (p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()),
            )
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
              backgroundColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: 0.1),
              child: Text(
                p.name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(p.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    const Icon(Icons.qr_code, size: 16),
                    Text('${p.id}'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  spacing: 10,
                  children: [
                    const Icon(Icons.inventory_2, size: 16),
                    Text('${p.quantity}'),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit(p.id);
                } else if (value == 'delete') {
                  onDelete(p.id, true);
                }
              },
              itemBuilder:
                  (_) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.create_outlined, size: 16),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            size: 16,
                            color: Colors.red,
                          ),
                          Text('Eliminar', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }
}
