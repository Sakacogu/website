import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/items/class_items.dart';
import 'package:website/items/items.dart';
import 'package:website/buttons/horizontal_buttons.dart';
import 'package:website/data/categories.dart';

class Clothes extends StatefulWidget {
  final String initialCategory;
  const Clothes({super.key, required this.initialCategory});

  @override
  State<Clothes> createState() => _ClothesState();
}

class _ClothesState extends State<Clothes> {
  late String selectedCategoryId;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.initialCategory;
  }

  List<Product> get filteredProducts {
    if (selectedCategoryId == '0') {
      return products;
    }
    return products.where((product) => product.id == selectedCategoryId).toList();
  }

  void _updateCategory(String categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          offset: const Offset(20, 50),
          onSelected: (value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Clothes(initialCategory: value),
              ),
            );
          },
          itemBuilder: (context) {
            return categories.map((category) {
              return PopupMenuItem<String>(
                value: category['categoryId'],
                child: Text(category['label']),
              );
            }).toList();
          },
        ),
        title: Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
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
      ),
      body: Column(
        children: [
          CategoryRow(
            onCategorySelected: _updateCategory,
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3/4,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.asset(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('\$${product.price.toStringAsFixed(2)}'),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
