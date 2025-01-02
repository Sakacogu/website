import 'package:flutter/material.dart';

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

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void resetSelections() {
    _selectedCategoryId;
    _selectedSubcategory;
    _searchQuery = '';
    notifyListeners();
  }
}
