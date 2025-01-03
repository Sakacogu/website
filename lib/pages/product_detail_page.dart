import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:website/items/product.dart';
import 'package:website/pages/products_screen.dart';
import 'package:website/providers/category_provider.dart';
import 'package:website/widgets/menu_button.dart';
import 'package:website/pages/home_screen.dart';
import 'package:website/widgets/subcategory_row.dart';
import 'package:website/widgets/category_row.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
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
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      categoryProvider.updateSearchQuery(value);

      if (value.isNotEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPaddingLeft = 20.0;
    double horizontalPaddingRight = screenWidth * 0.70;
    double verticalPaddingTop = 5.0;
    double verticalPaddingBottom = 0.0;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(ctx).openDrawer();
            },
          ),
        ),
        title: Stack(
          children: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                  Provider.of<CategoryProvider>(context, listen: false).updateCategory(null);
                  Provider.of<CategoryProvider>(context, listen: false).updateSubcategory(null);
                },
                child: Text(
                  'Fatavörubúð',
                  style: GoogleFonts.besley(
                    color: Colors.white,
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            Positioned(
              left: horizontalPaddingLeft,
              right: horizontalPaddingRight,
              top: verticalPaddingTop,
              bottom: verticalPaddingBottom,
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Hverju ertu að leita að?',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        Provider.of<CategoryProvider>(context, listen: false)
                            .updateSearchQuery('');
                        setState(() {});
                      },
                    )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                          catId.isEmpty ? null : catId
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  if (selectedCategoryId != '0') ...[
                    CategoryRowSubcategory(
                      selectedSubcategory: selectedSubcategory,
                      onSubcategorySelected: (subcat) {
                        categoryProvider.updateSubcategory(
                            subcat.isEmpty ? null : subcat);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const ProductsScreen()),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                            child: Icon(
                                Icons.error,
                                size: 50
                            ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${product.price} kr',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Litur: ${product.color}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${product.name} bætt í körfu!'),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Bæta í körfu'),
                              ),
                              const SizedBox(width: 16),
                              OutlinedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${product.name} vistað!'),
                                    ),
                                  );
                                  setState(() {
                                    product.saveCount ++;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.white),
                                ),
                                child: const Text('Vista'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
