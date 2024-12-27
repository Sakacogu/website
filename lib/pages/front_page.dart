import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/data/items.dart';
import 'package:website/widgets/product_card.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Featured Products',
          style: GoogleFonts.besley(
            color: Colors.white,
            fontSize: 24,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(product: product);
        },
      ),
    );
  }
}