import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  String _selectedCategoryId = '0';
  String? _selectedSubcategory;
  String _searchQuery = '';

  String get selectedCategoryId => _selectedCategoryId;
  String? get selectedSubcategory => _selectedSubcategory;
  String get searchQuery => _searchQuery;

  void updateCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void updateSubcategory(String? subcategory) {
    _selectedSubcategory = subcategory;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void resetSelections() {
    _selectedCategoryId = '0';
    _selectedSubcategory = null;
    _searchQuery = '';
    notifyListeners();
  }
}
