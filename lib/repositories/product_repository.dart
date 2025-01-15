import 'package:website/models/product.dart';
import 'package:website/data/items.dart';

// Repository sem veitir aðgang að vörum.
// Sækir frá items.dart fyrir favorites_page en hægt að nýta fyrir annað.
class ProductRepository {
  // Sækir hverja vöru eftir id
  static Product? getProductById(String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Skilar öllum vörum
  static List<Product> getAllProducts() {
    return products;
  }

  // Sækir vörur eftir undirflokk (subcategory)
  static List<Product> getProductsBySubcategory(String subcategory) {
    return products
        .where((product) => product.subcategory.toLowerCase() == subcategory.toLowerCase())
        .toList();
  }
}
