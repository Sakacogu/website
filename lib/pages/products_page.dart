import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:website/providers/category_provider.dart';
import 'package:website/data/items.dart';
import 'package:website/models/product.dart';
import 'package:website/widgets/menu_button.dart';
import 'package:website/widgets/category_row.dart';
import 'package:website/widgets/subcategory_row.dart';
import 'package:website/widgets/product_card.dart';
import 'package:website/widgets/app_bar.dart';

// Þetta er síða sem birtir vörur eftir flokk og undirflokk.
class ProductsScreen extends StatelessWidget {
  final String? initialCategory;
  final String? initialSubcategory;

  const ProductsScreen({
    super.key,
    this.initialCategory,
    this.initialSubcategory,
  });

  @override
  Widget build(BuildContext context) {
    final catProvider = Provider.of<CategoryProvider>(context);
    final selectedCategoryId = catProvider.selectedCategoryId;
    final selectedSubcategory = catProvider.selectedSubcategory;

    List<Product> filteredProducts;

    // Logík: ef enginn flokkur valinn => allt
    if (selectedCategoryId == null) {
      filteredProducts = List.from(products);
    }
    // Ef categoryId == "0" => Allar vörur
    else if (selectedCategoryId == '0') {
      if (selectedSubcategory == null || selectedSubcategory == 'Allar vörur') {
        filteredProducts = List.from(products);
      } else {
        filteredProducts = products.where((p) =>
        p.subcategory.toLowerCase() == selectedSubcategory.toLowerCase()
        ).toList();
      }
    } else {
      // Annar flokkur (1,2,3)
      if (selectedSubcategory == null || selectedSubcategory == 'Allar vörur') {
        filteredProducts = products.where((p) =>
        p.categoryId == selectedCategoryId
        ).toList();
      } else {
        filteredProducts = products.where((p) =>
        p.categoryId == selectedCategoryId &&
            p.subcategory.toLowerCase() == selectedSubcategory.toLowerCase()
        ).toList();
      }
    }

    return Scaffold(
      appBar: const MyAppBar(),   // Notar uppsettan app bar (titil línu)
      drawer: const AppDrawer(), // Notar uppsetta hamborgara menu takkann (menu_button)

      body: Column(
        children: [
          const SizedBox(height: 0),
          // CategoryRow til að skipta um flokk
          CategoryRow(
            selectedCategoryId: selectedCategoryId ?? '',
            onCategorySelected: (catId) {
              catProvider.updateCategory(catId.isEmpty ? null : catId);
            },
          ),
          const SizedBox(height: 10),

          // Ef flokkur var valinn þá sýna undirflokka
          if (selectedCategoryId != null) ...[
            CategoryRowSubcategory(
              selectedSubcategory: selectedSubcategory,
              onSubcategorySelected: (subcat) {
                catProvider.updateSubcategory(subcat.isEmpty ? null : subcat);
              },
            ),
            const SizedBox(height: 10),
          ],

          // Sýnum vörur sem passa við filter
          Expanded(
            child: filteredProducts.isNotEmpty
                ? GridView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,   // 2 í hverri röð
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2 / 2,
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
