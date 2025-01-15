import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:website/providers/favorites_provider.dart';
import 'package:website/models/product.dart';
import 'package:website/widgets/product_card.dart';
import 'package:website/repositories/product_repository.dart';
import 'package:website/widgets/menu_button.dart';
import 'package:website/widgets/app_bar.dart';

// Þessi síða sýnir vörur sem notandinn hefur sett hjarta við(Favorite).

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  // Sækir vörur sem eru í uppáhaldi (favoriteIds) og flettir þeim í ProductRepository.
  List<Product> getFavoriteProducts(Set<String> favoriteIds) {
    return favoriteIds
        .map((id) => ProductRepository.getProductById(id))
        .whereType<Product>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),   // Notar uppsettan app bar (titil línu)
      drawer: const AppDrawer(), // Notar uppsetta hamborgara menu takkann (menu_button)

      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          // Sækir product IDs í uppáhaldi úr FavoritesProvider
          final favoriteIds = favoritesProvider.favoriteProductIds;
          final favoriteProducts = getFavoriteProducts(favoriteIds);

          // Ef listinn er tómur, birtist "Ekkert hér enn!"
          if (favoriteProducts.isEmpty) {
            return const Center(
              child: Text(
                'Ekkert hér enn!',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // Annars eru birt spjöld af uppáhalds vörum sem hafa verið sett hjörtu við
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: favoriteProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,    // 2 vörur í röð
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2 / 2,
              ),
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return ProductCard(product: product);
              },
            ),
          );
        },
      ),
    );
  }
}
