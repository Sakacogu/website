import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:website/models/product.dart';
import 'package:website/pages/product_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:website/providers/favorites_provider.dart';

// Vörurnar eru sýndar á ProductCardi á helstu síðunum.
// Þegar smellt er á cardið, förum við í ProductDetailPage til að skoða vöru nánar.

class ProductCard extends StatelessWidget {

  final Product product;
  ProductCard({super.key, required this.product});

  // Stillir útlitið á verðinu
  final NumberFormat priceFormatter = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      margin: EdgeInsets.zero,
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Færar notandann í ProductDetailPage þegar ýtt er á cardið
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stækkar og setur mynd ofan á útlist kassan
            Expanded(
              child: Stack(
                children: [
                  // Mynd af vörunni
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.error));
                      },
                    ),
                  ),

                  // Hjartalaga hnappur efst í hægra horni á myndinni til að bæta henni í uppáhalds
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Selector<FavoritesProvider, bool>(
                      selector: (_, provider) => provider.isFavorite(product.id),
                      builder: (context, isFavorite, child) {
                        return GestureDetector(
                          onTap: () {
                            Provider.of<FavoritesProvider>(context, listen: false)
                                .toggleFavoriteStatus(product);
                          },
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.white,
                            size: 24,
                            shadows: [
                              Shadow(
                                blurRadius: 2,
                                color: Colors.black.withOpacity(1),
                                offset: const Offset(0, 0),
                              ),
                            ],
                            semanticLabel: isFavorite
                                ? 'Remove from favorites'
                                : 'Add to favorites',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Nafn vörunnar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Verð á vöru
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '${priceFormatter.format(product.price)}kr',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
