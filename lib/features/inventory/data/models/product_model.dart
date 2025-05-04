class ProductModel {
  final int? id;
  final String name;
  final int quantity;
  final DateTime? createdAt;
  final DateTime updatedAt;

  ProductModel({
    this.id,
    required this.name,
    required this.quantity,
    this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{
      'name': name,
      'quantity': quantity,
      'updated_at': updatedAt.toIso8601String(),
    };
    if (createdAt != null) {
      m['created_at'] = createdAt!.toIso8601String();
    }
    if (id != null) {
      m['id'] = id;
    }
    return m;
  }

  ProductModel copyWith({
    int? id,
    String? name,
    int? quantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}