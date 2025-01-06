import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:website/items/product.dart';
import 'package:website/pages/products_screen.dart';
import 'package:website/providers/category_provider.dart';
import 'package:website/widgets/menu_button.dart';
import 'package:website/pages/home_screen.dart';
import 'package:website/widgets/subcategory_row.dart';
import 'package:website/widgets/category_row.dart';
import 'package:website/widgets/app_bar.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String? _selectedSize;

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final categoryProvider =
      Provider.of<CategoryProvider>(context, listen: false);
      categoryProvider.updateSearchQuery(value);

      if (value.isNotEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
              (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: MyAppBar(
        showSearch: true,
        searchController: _searchController,
        onSearchChanged: _onSearchChanged,
      ),
      drawer: const AppDrawer(),
      body: Column(
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
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 500,
                  ),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 550,
                        height: 750,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.error, size: 50),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                '${product.price} kr',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Size:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 10),
                                  DropdownButton<String>(
                                    value: _selectedSize,
                                    hint: const Text('Select Size'),
                                    items: <String>['XS', 'S', 'M', 'L', 'XL']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedSize = newValue;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: _selectedSize == null
                                        ? null
                                        : () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'bætt í körfu!'),
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
                                  IconButton(
                                    icon: const Icon(Icons.favorite_border),
                                    color: Colors.red,
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                          content: const Text(
                                          'Vistað!'
                                          ),
                                          ),
                                      );
                                    },
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
            ),
          ),
        ],
      ),
    );
  }
}