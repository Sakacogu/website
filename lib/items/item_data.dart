import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/items/class_items.dart';
import 'package:website/items/items.dart';
import 'package:website/front_page/front_buttons.dart';

class Clothes extends StatefulWidget {
  final String initialCategory;

  const Clothes({super.key, required this.initialCategory});

  @override
  State<Clothes> createState() => _ClothesState();
}

class _ClothesState extends State <Clothes> {
  late String selectedCategoryId;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.initialCategory;
  }

  List <Product> get filteredProducts {
    if (selectedCategoryId == '0') {
      return products;
  }
    return products.where((product) => product.id == selectedCategoryId).toList();
}


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
      body: Column(
        children: [
        SingleChildScrollView(
        scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CategoryButton(
                  label: 'Allar vörur',
                  onPressed: () {
                    setState(() {
                      selectedCategoryId = '0';
                    });
                  },
                ),
                CategoryButton(
                  label: 'Konur',
                  onPressed: () {
                    setState(() {
                      selectedCategoryId = '1';
                    });
                  },
                ),
                CategoryButton(
                  label: 'Karlar',
                  onPressed: () {
                    setState(() {
                      selectedCategoryId = '2';
                    });
                  },
                ),
                CategoryButton(
                  label: 'Börn',
                  onPressed: () {
                    setState(() {
                      selectedCategoryId = '3';
                    });
                  },
                ),
              ],
            ),
        ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  child: ListTile(
                    leading: Image.asset(product.imageUrl),
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
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