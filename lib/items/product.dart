class Product {
  final String id;
  final String name;
  final String color;
  final double price;
  final String imageUrl;
  final String description;
  final String subcategory;
  int saveCount;

  Product({
    required this.id,
    required this.name,
    required this.color,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.subcategory,
    this.saveCount = 0,
  });
}
