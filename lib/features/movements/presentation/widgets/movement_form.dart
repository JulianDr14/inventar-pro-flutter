import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intentary_pro/core/di/core_providers.dart';
import 'package:intentary_pro/core/di/shared_providers.dart';
import 'package:intentary_pro/core/services/snackbar_service.dart';
import 'package:intentary_pro/features/inventory/domain/entities/product.dart';
import 'package:intentary_pro/features/movements/di/movements_providers.dart';
import 'package:intentary_pro/features/movements/domain/entities/inventory_movement.dart';
import 'package:intentary_pro/features/movements/presentation/viewmodel/movement_list_view_model.dart';
import 'package:intentary_pro/features/movements/presentation/widgets/movement_type_widget.dart';

class MovementForm extends ConsumerStatefulWidget {
  const MovementForm({super.key});

  @override
  ConsumerState<MovementForm> createState() => _MovementFormState();
}

class _MovementFormState extends ConsumerState<MovementForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _selectedProductId;
  final TextEditingController _qtyCtrl = TextEditingController();
  MovementType _selectedType = MovementType.incoming;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SharedProductListState sharedState = ref.watch(
      sharedProductListProvider,
    );
    final MovementListViewModel movementVM = ref.read(
      movementListViewModelProvider.notifier,
    );

    final List<Product> products = sharedState.products;
    final bool loading = sharedState.loading;
    final String? error = sharedState.error;

    final Product? selectedProduct =
        _selectedProductId != null
            ? products.firstWhere((p) => p.id == _selectedProductId)
            : null;
    final int qty = int.tryParse(_qtyCtrl.text) ?? 0;
    final bool showSummary = selectedProduct != null && qty > 0;

    Future<void> saveMovement() async {
      if (!_formKey.currentState!.validate()) return;

      await movementVM.addMovement(
        InventoryMovement(
          productId: _selectedProductId!,
          type: _selectedType,
          quantity: qty,
          createdAt: DateTime.now(),
        ),
      );
      await ref.read(sharedProductListProvider.notifier).loadProducts();
      if (!context.mounted) return;
      SnackbarService.show(
        context,
        message: 'Movimiento registrado correctamente',
      );
      context.pop();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(error, style: const TextStyle(color: Colors.red)),
              ),

            if (loading && products.isEmpty) ...[
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Center(child: Text('Cargando productos...')),
            ],

            if (!loading && products.isEmpty)
              const Center(child: Text('No hay productos disponibles.')),

            if (products.isNotEmpty)
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                        Text(
                          'Registrar movimiento',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedProductId,
                      items:
                          products
                              .map(
                                (p) => DropdownMenuItem(
                                  value: p.id,
                                  child: Text('${p.name} (stock: ${p.quantity})'),
                                ),
                              )
                              .toList(),
                      decoration: const InputDecoration(labelText: 'Producto'),
                      validator:
                          (v) => v == null ? 'Selecciona un producto' : null,
                      onChanged: (v) => setState(() => _selectedProductId = v),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tipo de movimiento',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    MovementTypeWidget(
                      selectedType: _selectedType,
                      onTypeChanged:
                          (newType) => setState(() => _selectedType = newType),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _qtyCtrl,
                      decoration: const InputDecoration(labelText: 'Cantidad'),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      validator: (v) {
                        final val = int.tryParse(v ?? '');
                        if (val == null) return 'Cantidad inválida';
                        if (_selectedType == MovementType.outgoing) {
                          final stock = selectedProduct?.quantity ?? 0;
                          if (val > stock) {
                            return 'No puedes sacar más de $stock unidades';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    if (showSummary)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resumen',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text('Producto: ${selectedProduct.name}'),
                            Text('Cantidad: $qty'),
                            Text(
                              'Nueva cantidad: ${_selectedType == MovementType.incoming ? selectedProduct.quantity + qty : selectedProduct.quantity - qty}',
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: saveMovement,
                        child: const Text('Guardar'),
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (context.canPop()) context.pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
