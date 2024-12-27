import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/pages/product_pages.dart';
import 'package:website/buttons/menu_button.dart';
import 'package:website/buttons/horizontal_buttons.dart';
import 'package:website/buttons/subcategory_buttons.dart';
import 'package:website/items/class_items.dart';
import 'package:website/items/items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategoryId = '0';
  String? selectedSubcategory;

  late List<Product> displayedProducts;

  @override
  void initState() {
    super.initState();
    displayedProducts = List.from(products);
  }
  void updateCategory(String categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      selectedSubcategory = null;
      if (categoryId == '0') {
        displayedProducts = List.from(products);
      } else {
        displayedProducts =
            products.where((product) => product.id == categoryId).toList();
      }
    });
  }
  void updateSubcategory(String? subcategory) {
    setState(() {
      selectedSubcategory = subcategory;
      if (subcategory == null || subcategory == 'Allar vörur') {
        if (selectedCategoryId == '0') {
          displayedProducts = List.from(products);
        } else {
          displayedProducts =
              products.where((product) => product.id == selectedCategoryId).toList();
        }
      } else {
        displayedProducts = products.where((product) {
          return (selectedCategoryId == '0' || product.id == selectedCategoryId) &&
              product.subcategory == subcategory;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
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
      drawer: AppDrawer(
        currentCategoryId: selectedCategoryId,
        currentSubcategoryId: selectedSubcategory,
        onCategorySelected: (categoryId) {
          updateCategory(categoryId);
          Navigator.pop(context);
          if (categoryId == '0') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Clothes(initialCategory: categoryId)
              ),
            );
          }
        },
        onSubcategorySelected: (subcategoryId) {
          updateSubcategory(subcategoryId == 'Allar vörur' ? null : subcategoryId);
          Navigator.pop(context);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 0.0
            ),
            child: CategoryRow(
              selectedCategoryId: selectedCategoryId,
              onCategorySelected: (categoryId) {
                updateCategory(categoryId);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 10.0
            ),
            child: CategoryRowSubcategory(
              selectedSubcategory: selectedSubcategory,
              onSubcategorySelected: (subcategoryId) {
                updateSubcategory(subcategoryId);
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: displayedProducts.isNotEmpty
                  ? GridView.builder(
                itemCount: displayedProducts.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) {
                  final product = displayedProducts[index];
                  return Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('${product.price} kr'),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              product.color,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ):
              const Center(
                child: Text(
                  'Engar vörur fundust.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
