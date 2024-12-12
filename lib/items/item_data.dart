import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/items/class_items.dart';
import 'package:website/items/items.dart';

class Clothes extends StatelessWidget {
  const Clothes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fatavörubúð',
          style: GoogleFonts.besley(
            color: Colors.white,
            fontSize: 24,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: ListTile(
              leading: Image.asset(product.imageUrl),
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            ),
          );
        },
      ),
    );
  }
}