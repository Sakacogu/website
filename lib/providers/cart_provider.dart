import 'package:flutter/material.dart';
import 'package:website/items/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    final index = _items.indexWhere((cartItem) =>
    cartItem.product.id == item.product.id &&
        cartItem.size == item.size);
    if (index >= 0) {
      _items[index] = CartItem(
        product: _items[index].product,
        size: _items[index].size,
        quantity: _items[index].quantity + 1,
      );
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    final index = _items.indexWhere((cartItem) =>
    cartItem.product.id == item.product.id &&
        cartItem.size == item.size);
    if (index >= 0) {
      _items[index] = CartItem(
        product: _items[index].product,
        size: _items[index].size,
        quantity: _items[index].quantity + 1,
      );
      notifyListeners();
      print('Increased quantity for ${item.product.name} to ${_items[index].quantity}');
    } else {
      print('Item not found in cart: ${item.product.name}');
    }
  }

  void decreaseQuantity(CartItem item) {
    final index = _items.indexWhere((cartItem) =>
    cartItem.product.id == item.product.id &&
        cartItem.size == item.size);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index] = CartItem(
          product: _items[index].product,
          size: _items[index].size,
          quantity: _items[index].quantity - 1,
        );
        print('Decreased quantity for ${item.product.name} to ${_items[index].quantity}');
      } else {
        _items.removeAt(index);
        print('Removed item ${item.product.name} from cart');
      }
      notifyListeners();
    } else {
      print('Item not found in cart: ${item.product.name}');
    }
  }
}
