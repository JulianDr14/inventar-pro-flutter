import 'package:flutter/material.dart';
import 'package:intentary_pro/features/movements/domain/entities/inventory_movement.dart';

typedef MovementTypeChanged = void Function(MovementType newType);

class MovementTypeWidget extends StatelessWidget {
  final MovementType selectedType;
  final MovementTypeChanged onTypeChanged;

  const MovementTypeWidget({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      spacing: 16,
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => onTypeChanged(MovementType.incoming),
            icon: const Icon(Icons.arrow_circle_up_outlined),
            label: const Text('Entrada'),
            style: FilledButton.styleFrom(
              backgroundColor:
                  selectedType == MovementType.incoming
                      ? Theme.of(context).colorScheme.primary
                      : isDark
                      ? Colors.white24
                      : Colors.white,
              foregroundColor:
                  selectedType == MovementType.incoming
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: FilledButton.icon(
            onPressed: () => onTypeChanged(MovementType.outgoing),
            icon: const Icon(Icons.arrow_circle_down_outlined),
            label: const Text('Salida'),
            style: FilledButton.styleFrom(
              backgroundColor:
                  selectedType == MovementType.outgoing
                      ? Colors.red
                      : isDark
                      ? Colors.white24
                      : Colors.white,
              foregroundColor:
                  selectedType == MovementType.outgoing
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
