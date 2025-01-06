import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/widgets/menu_button.dart';
import 'package:website/data/items.dart';
import 'package:website/items/product.dart';
import 'package:website/widgets/category_row.dart';
import 'package:website/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:website/providers/category_provider.dart';
import 'package:website/pages/products_screen.dart';
import 'package:website/widgets/app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key
  });

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      Provider.of<CategoryProvider>(context, listen: false)
          .updateSearchQuery(value);
    });
  }

  @override
  Widget build(BuildContext context) {

    final popularItems = getPopularProducts();
    final category1Items = _categoryItems('1');
    final category2Items = _categoryItems('2');
    final category3Items = _categoryItems('3');

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: MyAppBar(
        searchController: _searchController,
        onSearchChanged: (value) {

        },
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Consumer<CategoryProvider>(
                builder: (context, catProvider, child) {
                  return CategoryRow(
                    selectedCategoryId: catProvider.selectedCategoryId ?? '',
                    onCategorySelected: (catId) {
                      catProvider.updateCategory(
                          catId.isEmpty ? null : catId
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductsScreen(
                            initialCategory: catId.isEmpty ? null : catId,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10
              ),
              child: Text(
                'Vinsælar vörur',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularItems.length,
                itemBuilder: (context, index) {
                  final product = popularItems[index];
                  return SizedBox(
                    width: 270,
                    child: ProductCard(product: product),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 20),
            _buildCategoryRow(context, 'Konur', category1Items),

            const SizedBox(height: 20),
            _buildCategoryRow(context, 'Karlar', category2Items),

            const SizedBox(height: 20),
            _buildCategoryRow(context, 'Börn', category3Items),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  List<Product> _categoryItems(String id) {
    return products.where((p) => p.id == id).toList();
  }
  Widget _buildCategoryRow(
      BuildContext context,
      String categoryTitle,
      List<Product> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            categoryTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 350,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              return SizedBox(
                width: 270,
                child: ProductCard(product: product),
              );
            },
          ),
        ),
      ],
    );
  }
}

