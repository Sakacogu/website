import 'dart:math';
import 'package:flutter/material.dart';
import 'package:website/data/items.dart';
import 'package:website/models/product.dart';

// Sér um hvaða flokkur og undirflokkur er valinn á öllum síðum.
class CategoryProvider with ChangeNotifier {
  String? _selectedCategoryId;
  String? _selectedSubcategory;
  String _searchQuery = '';

  String? get selectedCategoryId => _selectedCategoryId;
  String? get selectedSubcategory => _selectedSubcategory;
  String get searchQuery => _searchQuery;

  void updateCategory(String? newCategory) {
    _selectedCategoryId = newCategory;
    notifyListeners();
  }

  void updateSubcategory(String? newSubcategory) {
    _selectedSubcategory = newSubcategory;
    notifyListeners();
  }

  void resetSelections() {
    _selectedCategoryId = null;
    _selectedSubcategory = null;
    _searchQuery = '';
    notifyListeners();
  }

    // Sækir vörur í viðeigandi flokk
    List<Product> categoryItems(String catId) {
      return products.where((p) => p.categoryId == catId).toList();
    }

  // Var áður = sækir vinsælar vörur eftir saveCount og skilar þeim í efstu línu á forsíðu (max 15).
  // En á meðan þetta er í vinnslu þá er þetta bara random vörur upp á útlit
  List<Product> getPopularProducts() {
    final List<Product> shuffled = List.from(products);
    shuffled.shuffle(Random(321));

    final int count = shuffled.length < 15 ? shuffled.length : 15;
    return shuffled.sublist(0, count);
  }

    List<Product> searchProductsByName(String query) {
      return products
          .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
