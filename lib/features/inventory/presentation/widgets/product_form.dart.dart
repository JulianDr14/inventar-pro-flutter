import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/features/inventory/domain/entities/product.dart';
import 'package:intentary_pro/core/services/snackbar_service.dart';

class ProductForm extends ConsumerStatefulWidget {
  /// Si viene un producto, el formulario está en modo "editar"
  final Product? product;

  /// Callback: en Add, id será null; en Edit, id == product.id
  final Future<void> Function({
  int? id,
  required String name,
  required int quantity,
  }) onSave;

  const ProductForm({
    this.product,
    required this.onSave,
    super.key,
  });

  @override
  ConsumerState<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends ConsumerState<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _qtyCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.product?.name ?? '');
    _qtyCtrl = TextEditingController(
      text: widget.product?.quantity.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    final qty = int.parse(_qtyCtrl.text.trim());
    final id = widget.product?.id;

    await widget.onSave(id: id, name: name, quantity: qty);

    if (!context.mounted) return;
    SnackbarService.show(
      context,
      message: widget.product == null
          ? 'Producto agregado'
          : 'Producto actualizado',
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Icon(
            isEdit ? Icons.edit_outlined : Icons.add_circle_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            isEdit ? 'Editar Producto' : 'Agregar Producto',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ]),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) =>
              v == null || v.isEmpty ? 'Ingresa un nombre' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _qtyCtrl,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || int.tryParse(v) == null
                  ? 'Cantidad inválida'
                  : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: Icon(isEdit ? Icons.save : Icons.check),
                label: Text(isEdit ? 'Guardar cambios' : 'Guardar producto'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ]),
    );
  }
}
