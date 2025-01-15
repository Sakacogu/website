import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:website/models/cart_item.dart';

// Heldur utan um körfuna og listann af CartItem.
// Hægt að bæta við, fjarlægja, auka/minnka magn, og vista í SharedPreferences.

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  CartProvider() {
    _loadCart();
  }

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    final index = _items.indexWhere((cartItem) =>
    cartItem.product.id == item.product.id && cartItem.size == item.size);
    if (index >= 0) {
      _items[index] = CartItem(
        product: _items[index].product,
        size: _items[index].size,
        quantity: _items[index].quantity + 1,
      );
    } else {
      _items.add(item);
    }
    _saveCart();
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    _saveCart();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    final index = _items.indexWhere((cartItem) =>
    cartItem.product.id == item.product.id && cartItem.size == item.size);
    if (index >= 0) {
      _items[index] = CartItem(
        product: _items[index].product,
        size: _items[index].size,
        quantity: _items[index].quantity + 1,
      );
      _saveCart();
      notifyListeners();
    } else {
    }
  }

  void decreaseQuantity(CartItem item) {
    final index = _items.indexWhere((cartItem) =>
    cartItem.product.id == item.product.id && cartItem.size == item.size);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index] = CartItem(
          product: _items[index].product,
          size: _items[index].size,
          quantity: _items[index].quantity - 1,
        );
      } else {
        _items.removeAt(index);
      }
      _saveCart();
      notifyListeners();
    } else {
    }
  }

  // Vistar körfu í SharedPreferences sem JSON
  // svo hægt sé að geyma hluti í körfu þrátt fyrir refresh
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartJson = _items.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList('cart', cartJson);
  }

  // Les körfu úr SharedPreferences
  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartJson = prefs.getStringList('cart');
    if (cartJson != null) {
      _items.clear();
      _items.addAll(cartJson.map((item) => CartItem.fromJson(json.decode(item))));
      notifyListeners();
    }
  }
}
