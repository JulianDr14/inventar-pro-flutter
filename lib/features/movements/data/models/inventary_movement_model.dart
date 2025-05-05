class MovementModel {
  final int? id;
  final int productId;
  final String nameProduct;
  final String type;
  final int quantity;
  final DateTime createdAt;

  MovementModel({
    this.id,
    required this.productId,
    this.nameProduct = '',
    required this.type,
    required this.quantity,
    required this.createdAt,
  });

  factory MovementModel.fromMap(Map<String, dynamic> map) {
    return MovementModel(
      id: map['id'] as int?,
      productId: map['product_id'] as int,
      nameProduct: map['name_product'] as String? ?? '',
      type: map['type'] as String,
      quantity: map['quantity'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{
      'product_id': productId,
      'type': type,
      'quantity': quantity,
      'created_at': createdAt.toIso8601String(),
    };
    if (id != null) m['id'] = id;
    return m;
  }
}
