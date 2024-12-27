import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/items/class_items.dart';
import 'package:website/items/items.dart';
import 'package:website/buttons/menu_button.dart';
import 'package:website/buttons/subcategory_buttons.dart';

class Clothes extends StatefulWidget {
  final String initialCategory;
  const Clothes({super.key, required this.initialCategory});

  @override
  State<Clothes> createState() => _ClothesState();
}

class _ClothesState extends State<Clothes> {
  late String selectedCategoryId;
  String? selectedSubcategory;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.initialCategory;
  }
  List<Product> get filteredProducts {
    if (selectedCategoryId == '0') {
      if (selectedSubcategory == null || selectedSubcategory == 'All') {
        return List.from(products);
      } else {
        return products.where((product) =>
        product.subcategory == selectedSubcategory).toList();
      }
    } else {
      if (selectedSubcategory == null || selectedSubcategory == 'All') {
        return products.where((product) => product.id == selectedCategoryId)
            .toList();
      } else {
        return products
            .where((product) =>
        product.id == selectedCategoryId &&
            product.subcategory == selectedSubcategory)
            .toList();
      }
    }
  }
  //??????????????
  void _updateCategory(String categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      selectedSubcategory = null;
    });
  }
//?????????????????
  void _updateSubcategory(String? subcategory) {
    setState(() {
      selectedSubcategory = subcategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      drawer: AppDrawer(
        currentCategoryId: selectedCategoryId,
        currentSubcategoryId: selectedSubcategory,
        onCategorySelected: (categoryId) {
          _updateCategory(categoryId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Clothes(initialCategory: categoryId),
            ),
          );
        },
        onSubcategorySelected: (subcategoryId) {
          _updateSubcategory(subcategoryId == 'All' ? null : subcategoryId);
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              hint: const Text('Veldu undirflokk'),
              value: selectedSubcategory,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: 'All',
                  child: Text('All'),
                ),
              ],
              onChanged: (value) {
                _updateSubcategory(value == 'All' ? null : value);
              },
            ),
          ),
          const SizedBox(height: 10),
          CategoryRowSubcategory(
            selectedSubcategory: selectedSubcategory,
            onSubcategorySelected: (subcategoryId) {
              _updateSubcategory(subcategoryId == 'All' ? null : subcategoryId);
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () { //fylla inni
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                  child: Icon(Icons.error)
                              );
                            },
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
                          child: Text('${product.price} kr'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.color,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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