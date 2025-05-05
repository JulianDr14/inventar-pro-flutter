enum MovementType { incoming, outgoing }

extension MovementTypeX on MovementType {
  String toSqlValue() {
    switch (this) {
      case MovementType.incoming:
        return 'IN';
      case MovementType.outgoing:
        return 'OUT';
    }
  }

  static MovementType fromSqlValue(String sqlValue) {
    switch (sqlValue) {
      case 'IN':
        return MovementType.incoming;
      case 'OUT':
        return MovementType.outgoing;
      default:
        throw ArgumentError('Tipo de movimiento desconocido: $sqlValue');
    }
  }
}

class InventoryMovement {
  final int? id;
  final int productId;
  final String? productName;
  final MovementType type;
  final int quantity;
  final DateTime createdAt;

  const InventoryMovement({
    this.id,
    required this.productId,
    this.productName,
    required this.type,
    required this.quantity,
    required this.createdAt,
  });
}
