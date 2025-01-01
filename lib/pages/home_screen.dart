import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/widgets/menu_button.dart';
import 'package:website/widgets/subcategory_row.dart';
import 'package:website/data/items.dart';
import 'package:website/items/product.dart';
import 'package:website/widgets/category_row.dart';
import 'package:website/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:website/providers/category_provider.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPaddingLeft = 20.0;
    double horizontalPaddingRight = screenWidth * 0.70;
    double verticalPaddingTop = 5.0;
    double verticalPaddingBottom = 0.0;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
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
                  Provider.of<CategoryProvider>(context, listen: false)
                      .updateCategory('0');
                  Provider.of<CategoryProvider>(context, listen: false)
                      .updateSubcategory('Allar vörur');
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
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
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
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          final selectedCategoryId = categoryProvider.selectedCategoryId;
          final selectedSubcategory = categoryProvider.selectedSubcategory;
          final searchQuery = categoryProvider.searchQuery;

          List<Product> filteredProducts;
          if (selectedCategoryId == '0') {
            if (selectedSubcategory == null || selectedSubcategory == 'Allar vörur') {
              filteredProducts = List.from(products);
            } else {
              filteredProducts =
                  products.where((p) => p.subcategory == selectedSubcategory).toList();
            }
          } else {
            if (selectedSubcategory == null || selectedSubcategory == 'Allar vörur') {
              filteredProducts =
                  products.where((p) => p.id == selectedCategoryId).toList();
            } else {
              filteredProducts = products.where((p) =>
              p.id == selectedCategoryId &&
                  p.subcategory.toLowerCase() == selectedSubcategory.toLowerCase()).toList();
            }
          }

          if (searchQuery.isNotEmpty) {
            filteredProducts = filteredProducts.where((product) {
              return product.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
                  product.description.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  product.color.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
            }).toList();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CategoryRow(
                selectedCategoryId: selectedCategoryId,
                onCategorySelected: (categoryId) {
                  categoryProvider.updateCategory(categoryId);
                },
              ),

              const SizedBox(height: 10),

              if (selectedCategoryId != '0') ...[
                CategoryRowSubcategory(
                  selectedSubcategory: selectedSubcategory,
                  onSubcategorySelected: (subcat) {
                    categoryProvider.updateSubcategory(
                        subcat == 'Allar vörur' ? null : subcat);
                  },
                ),

                const SizedBox(height: 10),

              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: filteredProducts.isNotEmpty
                      ? GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 4,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(product: product);
                    },
                  )
                      : const Center(
                    child: Text(
                      'Engar vörur fundust.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
