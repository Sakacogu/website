import 'package:flutter/material.dart';
import 'package:website/Pages//product_pages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/buttons/horizontal_buttons.dart';
import 'package:website/data/categories.dart';
import 'package:website/items/items.dart';
import 'package:website/items/class_items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> filteredProducts = products.where((p) => p.id == '1').toList();
    
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
            Navigator.push(
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
          Center(
        child: CategoryRow(
          onCategorySelected: (categoryId) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Clothes(initialCategory: categoryId),
              ),
            );
          },
        ),
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
