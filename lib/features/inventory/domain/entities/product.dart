class Product {
  final int id;
  final String name;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });
}