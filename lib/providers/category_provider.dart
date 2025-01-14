import 'package:flutter/material.dart';
import 'package:website/data/items.dart';
import 'package:website/items/product.dart';

// Sér um hvaða flokkur og undirflokkur er valinn.

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

    // Sækir vinsælar vörur eftir saveCount og skilar þeim í efstu línu á forsíðu (max 15).
    List<Product> getPopularProducts() {
      final List<Product> sorted = List.from(products);
      sorted.sort((a, b) => b.saveCount.compareTo(a.saveCount));

      final int count = sorted.length < 15 ? sorted.length : 15;
      return sorted.sublist(0, count);
    }

    List<Product> searchProductsByName(String query) {
      return products
          .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
