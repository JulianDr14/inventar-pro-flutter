import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/core/di/core_providers.dart';
import 'package:intentary_pro/features/inventory/di/inventory_providers.dart';
import 'package:intentary_pro/features/inventory/domain/entities/product.dart';
import 'package:intentary_pro/features/inventory/presentation/dialogs/confirm_delete_dialog.dart';

class ProductListContent extends ConsumerWidget {
  final void Function(int) onEdit;
  final void Function(int, bool) onDelete;

  const ProductListContent({
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Product> products = ref.watch(
      sharedProductListProvider.select((s) => s.products),
    );
    final bool isLoading = ref.watch(
      sharedProductListProvider.select((s) => s.loading),
    );
    final String? errorMsg = ref.watch(
      sharedProductListProvider.select((s) => s.error),
    );
    final String query = ref.watch(searchQueryProvider);

    final List<Product> filtered = products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMsg != null) {
      return Center(child: Text(errorMsg));
    }
    if (filtered.isEmpty) {
      return const Center(child: Text('No se encontraron productos'));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final p = filtered[i];
        return Dismissible(
          key: ValueKey(p.id),
          confirmDismiss: (direction) async {
            final ok = await ConfirmDeleteDialog.show(context);
            if (ok == true) {
              onDelete(p.id, false);
            }
            return ok;
          },
          background: _backgroundDismissible(context),
          secondaryBackground: _backgroundDismissible(context),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
              child: Text(
                p.name[0].toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(p.name),
            subtitle: Row(
              spacing: 10,
              children: [
                const Icon(Icons.qr_code, size: 16),
                Text('${p.id}'),
                const SizedBox(width: 16),
                const Icon(Icons.inventory_2, size: 16),
                Text('${p.quantity}'),
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
              itemBuilder: (_) => [
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
                      Text('Eliminar',
                          style: TextStyle(color: Colors.red),
                      ),
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

  Widget _backgroundDismissible(BuildContext context) => Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 16),
    color: Colors.red.withValues(alpha: 0.2),
    child: const Icon(Icons.delete, color: Colors.red),
  );
}
