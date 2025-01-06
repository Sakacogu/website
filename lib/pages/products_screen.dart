import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:website/providers/category_provider.dart';
import 'package:website/data/items.dart';
import 'package:website/items/product.dart';
import 'package:website/widgets/menu_button.dart';
import 'package:website/widgets/category_row.dart';
import 'package:website/widgets/subcategory_row.dart';
import 'package:website/widgets/product_card.dart';
import 'package:website/pages/home_screen.dart';
import 'package:website/widgets/app_bar.dart';


class ProductsScreen extends StatefulWidget {
  final String? initialCategory;
  final String? initialSubcategory;

  const ProductsScreen({
    super.key,
    this.initialCategory,
    this.initialSubcategory
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
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

    final catProvider = Provider.of<CategoryProvider>(context);
    final selectedCategoryId = catProvider.selectedCategoryId;
    final selectedSubcategory = catProvider.selectedSubcategory;
    final searchQuery = catProvider.searchQuery;

    List<Product> filteredProducts;

    if (selectedCategoryId == null) {
      filteredProducts = List.from(products);
    } else if (selectedCategoryId == '0') {
      if (selectedSubcategory == null || selectedSubcategory == 'Allar vörur') {
        filteredProducts = List.from(products);
      } else {
        filteredProducts = products.where(
              (p) => p.subcategory == selectedSubcategory,
        ).toList();
      }
    } else {
      if (selectedSubcategory == null || selectedSubcategory == 'Allar vörur') {
        filteredProducts = products.where(
              (p) => p.id == selectedCategoryId,
        ).toList();
      } else {
        filteredProducts = products.where(
              (p) =>
          p.id == selectedCategoryId &&
              p.subcategory.toLowerCase() == selectedSubcategory.toLowerCase(),
        ).toList();
      }
    }

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      filteredProducts = filteredProducts.where((product) {
        return product.name.toLowerCase().contains(q) ||
            product.description.toLowerCase().contains(q) ||
            product.color.toLowerCase().contains(q);
      }).toList();
    }

    return Scaffold(
        appBar: MyAppBar(
          searchController: _searchController,
          onSearchChanged: (value) {

          },
        ),
      drawer: const AppDrawer(),

      body: Column(
        children: [
          const SizedBox(height: 0),
          CategoryRow(
            selectedCategoryId: selectedCategoryId ?? '',
            onCategorySelected: (catId) {
              catProvider.updateCategory(
                  catId.isEmpty ? null : catId
              );
            },
          ),
          const SizedBox(height: 10),

          if (selectedCategoryId != null) ...[
            CategoryRowSubcategory(
              selectedSubcategory: selectedSubcategory,
              onSubcategorySelected: (subcat) {
                catProvider.updateSubcategory(
                    subcat.isEmpty ? null : subcat
                );
              },
            ),
            const SizedBox(height: 10),
          ],

          Expanded(
            child: filteredProducts.isNotEmpty
                ? GridView.builder(
              padding: const EdgeInsets.all(8.0),
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
        ],
      ),
    );
  }
}
