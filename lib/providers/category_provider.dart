import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  String _selectedCategoryId = '0';
  String? _selectedSubcategory;

  String get selectedCategoryId => _selectedCategoryId;
  String? get selectedSubcategory => _selectedSubcategory;

  void updateCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void updateSubcategory(String? subcategory) {
    _selectedSubcategory = subcategory;
    notifyListeners();
  }
}
