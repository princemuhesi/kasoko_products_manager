class Product {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String businessId;
  final double price;
  final int availableStock;

  Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.categoryId,
    required this.businessId,
    required this.price,
    required this.availableStock,
  });
}