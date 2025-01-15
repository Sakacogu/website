import 'package:flutter/material.dart';
import 'package:website/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Heldur utan um uppáhalds vörur (favoriteProductIds).
// Breytir listanum ef notandi ýtir á hjartatakkann
// Vistum í SharedPreferences svo það haldist þrátt fyrir refresh
// Á eftir að tengja almennilega

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteProductIds = {};

  FavoritesProvider() {
    _loadFavorites();
  }

  Set<String> get favoriteProductIds => _favoriteProductIds;

  bool isFavorite(String id) {
    return _favoriteProductIds.contains(id);
  }

  void toggleFavoriteStatus(Product product) {
    if (_favoriteProductIds.contains(product.id)) {
      _favoriteProductIds.remove(product.id);
    } else {
      _favoriteProductIds.add(product.id);
    }
    _saveFavorites();
    notifyListeners();
  }

  void addFavorite(Product product) {
    _favoriteProductIds.add(product.id);
    _saveFavorites();
    notifyListeners();
  }

  void removeFavorite(String id) {
    _favoriteProductIds.remove(id);
    _saveFavorites();
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteProductIds.clear();
    _saveFavorites();
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? ids = prefs.getStringList('favorites');
    if (ids != null) {
      _favoriteProductIds.addAll(ids);
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favoriteProductIds.toList());
  }
}
