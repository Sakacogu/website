import 'package:website/items/product.dart';

class CartItem {
  final Product product;
  final String size;
  late final int quantity;

  CartItem({
    required this.product,
    required this.size,
    this.quantity = 1,
  });
}
