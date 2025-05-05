import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/features/movements/di/movements_providers.dart';
import 'package:intentary_pro/features/movements/domain/entities/inventory_movement.dart';
import 'package:intentary_pro/features/movements/presentation/viewmodel/movement_list_view_model.dart';
import 'package:intentary_pro/features/movements/presentation/widgets/movement_form.dart';
import 'package:intl/intl.dart';

class MovementsListPage extends ConsumerStatefulWidget {
  const MovementsListPage({super.key});

  @override
  ConsumerState<MovementsListPage> createState() => _MovementsListPageState();
}

class _MovementsListPageState extends ConsumerState<MovementsListPage> {
  void _showMovementForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (ctx) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: const MovementForm(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MovementListState state = ref.watch(movementListViewModelProvider);

    return Scaffold(
      body: Builder(
        builder: (_) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          if (state.movements.isEmpty) {
            return const Center(child: Text('No hay movimientos registrados.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: state.movements.length,
            itemBuilder: (context, i) {
              final InventoryMovement m = state.movements[i];
              final bool isIn = m.type == MovementType.incoming;
              final Color qtyColor =
                  isIn ? Theme.of(context).colorScheme.primary : Colors.red;
              final IconData qtyIcon = isIn ? Icons.add : Icons.remove;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      isIn
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.2)
                          : Colors.red.withValues(alpha: 0.2),
                  child: Icon(
                    isIn ? Icons.arrow_circle_up : Icons.arrow_circle_down,
                    color: qtyColor,
                  ),
                ),
                title: Text(
                  m.productName ?? 'Sin nombre',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  DateFormat.yMd().add_jm().format(m.createdAt),
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  spacing: 2,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(qtyIcon, size: 16, color: qtyColor),
                    Text(
                      '${m.quantity}',
                      style: TextStyle(
                        fontSize: 16,
                        color: qtyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_movement_hero',
        onPressed: _showMovementForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
