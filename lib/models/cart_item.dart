import 'package:website/models/product.dart';

// Hvert CartItem inniheldur vöru, valda stærð og magn.
// Notað í CartProvider til að halda utan um körfuna.

class CartItem {
  final Product product;
  final String size;
  late final int quantity;

  CartItem({
    required this.product,
    required this.size,
    this.quantity = 1,
  });

  // Vistar CartItem sem JSON (t.d. til að skrifa í SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'size': size,
      'quantity': quantity,
    };
  }

  // Les CartItem úr JSON þannig það helst í cart þó síðan sé refreshuð
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      size: json['size'],
      quantity: json['quantity'],
    );
  }
}
