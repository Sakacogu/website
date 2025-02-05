// Skilgreining á Product-líkani.
// Nýtist samhliða items.dart

class Product {
  final String categoryId;  // Stóru flokkarnir konur, karlar, börn
  final String id;          // Auðkenni fyrir hverja staka vöru (F1, F2, etc.)
  final String name;
  final String color;
  final double price;
  final String imageUrl;
  final String description;
  final String subcategory;
  int saveCount;

  Product({
    required this.categoryId,
    required this.id,
    required this.name,
    required this.color,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.subcategory,
    this.saveCount = 0,
  });

  // Til að vista í JSON
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'price': price,
      'imageUrl': imageUrl,
      'subcategory': subcategory,
      'saveCount': saveCount,
    };
  }

  // Til að lesa úr JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      categoryId: json['categoryId'],
      id: json['id'],
      name: json['name'],
      description: json['description'],
      color: json['color'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      subcategory: json['subcategory'],
      saveCount: (json['saveCount'] ?? 0) as int,
    );
  }
}
