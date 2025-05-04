import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/features/inventory/di/inventory_providers.dart';

class ProductListContent extends ConsumerWidget {
  final String searchQuery;
  final void Function(int) onEdit;
  final void Function(int) onDelete;

  const ProductListContent({
    required this.searchQuery,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productListViewModelProvider);
    final products =
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
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).primaryColor.withValues(alpha: 0.1),
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
                onDelete(p.id);
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
        );
      },
    );
  }
}
