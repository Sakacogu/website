import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:website/models/product.dart';
import 'package:website/pages/products_page.dart';
import 'package:website/providers/category_provider.dart';
import 'package:website/widgets/menu_button.dart';
import 'package:website/widgets/subcategory_row.dart';
import 'package:website/widgets/category_row.dart';
import 'package:website/widgets/app_bar.dart';
import 'package:website/providers/cart_provider.dart';
import 'package:website/models/cart_item.dart';
import 'package:website/providers/favorites_provider.dart';

// Sýnir smáatriðin um hverja vöru (mynd, lýsing, verð, stærð...)
class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  // Stillir útlitið á verðinu
  final NumberFormat priceFormatter = NumberFormat("#,###");

  // Tekur við stærðarvalinu í dropdown menuinu
  String? _selectedSize;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Skoðum skjábreidd til að skipta upp layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 700;

    return Scaffold(
      appBar: const MyAppBar(),   // Notar uppsettan app bar (titil línu)
      drawer: const AppDrawer(), // Notar uppsetta hamborgara menu takkann (menu_button)

      // GestureDetector eða Listener til að loka snackbar þegar notandi heldur áfram notkun á forritinu
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: Column(
          children: [
            // Ef notandi er að skoða tiltekinn flokk, birtum CategoryRow
            Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                final selectedCategoryId = categoryProvider.selectedCategoryId;
                final selectedSubcategory = categoryProvider.selectedSubcategory;

                return Column(
                  children: [
                    CategoryRow(
                      selectedCategoryId: selectedCategoryId ?? '',
                      onCategorySelected: (catId) {
                        categoryProvider.updateCategory(
                            catId.isEmpty ? null : catId);
                      },
                    ),
                    const SizedBox(height: 10),
                    // Þegar flokkur er valinn eru undirflokkar birtir
                    if (selectedCategoryId != null || selectedCategoryId == '0') ...[
                      CategoryRowSubcategory(
                        selectedSubcategory: selectedSubcategory,
                        onSubcategorySelected: (subcat) {
                          categoryProvider.updateSubcategory(
                              subcat.isEmpty ? null : subcat);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const ProductsScreen()),
                                (Route<dynamic> route) => false,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                );
              },
            ),

            // Aðal svæðið sem sýnir mynd + upplýsingar um vöruna
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: isNarrow
                        ? _buildVerticalLayout(context, product, cartProvider)
                        : _buildHorizontalLayout(context, product, cartProvider),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ef skjár er mjór (isNarrow), er myndin sett efst og textinn fyrir neðan
  Widget _buildVerticalLayout(BuildContext context, Product product,
      CartProvider cartProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 4 / 5,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.error)),
          ),
        ),
        const SizedBox(height: 16),
        _buildProductDetails(context, product, cartProvider),
      ],
    );
  }

  // Ef skjár er breiður, setjum myndina vinstra megin og textann hægra megin
  Widget _buildHorizontalLayout(BuildContext context, Product product,
      CartProvider cartProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: AspectRatio(
            aspectRatio: 4 / 5,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.error)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: _buildProductDetails(context, product, cartProvider),
          ),
        ),
      ],
    );
  }

  // Upplýsingar um vöruna (nafn, lýsing, litur, verð, stærðir)
  Widget _buildProductDetails(
      BuildContext context, Product product, CartProvider cartProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          product.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          product.description,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Litur: ${product.color}',
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Verð: ${priceFormatter.format(product.price)}kr',
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),

        // Velja stærð (Dropdown)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Stærð:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: _selectedSize,
              hint: const Text('Veldu stærð'),
              items: <String>['XS', 'S', 'M', 'L', 'XL']
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSize = newValue;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Hnappur til að bæta í körfu og hnappur til að bæta í uppáhalds
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _selectedSize == null
                  ? null
                  : () {
                cartProvider.addItem(CartItem(
                  product: product,
                  size: _selectedSize!,
                  quantity: 1,
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bætt í körfu!')),
                );
              },
              child: const Text('Bæta í körfu'),
            ),
            const SizedBox(width: 16),
            Selector<FavoritesProvider, bool>(
              selector: (_, favoritesProv) => favoritesProv.isFavorite(product.id),
              builder: (ctx, isFav, _) {
                return IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                  color: isFav ? Colors.red : Colors.grey,
                  onPressed: () {
                    Provider.of<FavoritesProvider>(context, listen: false)
                        .toggleFavoriteStatus(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFav ? 'Fjarlægt úr uppáhalds.' : 'Bætt í uppáhalds!',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
