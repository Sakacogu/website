import 'package:flutter/material.dart';
import 'package:website/providers/category_provider.dart';
import 'package:website/widgets/menu_button.dart';
import 'package:website/models/product.dart';
import 'package:website/widgets/category_row.dart';
import 'package:website/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:website/pages/products_page.dart';
import 'package:website/widgets/app_bar.dart';

// Þetta er forsíðan
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    // Sækir viðeigandi flokka
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    // Sækir vinsælar vörur með getPopularProducts() til að birta efst á síðunni
    final popularItems = categoryProvider.getPopularProducts();
    // Vörur sem tilheyra flokkum "Konur", "Karlar", "Börn"
    final category1Items = categoryProvider.categoryItems('1');
    final category2Items = categoryProvider.categoryItems('2');
    final category3Items = categoryProvider.categoryItems('3');

    return Scaffold(
      appBar: const MyAppBar(),   // Notar uppsettan app bar (titil línu)
      drawer: const AppDrawer(), // Notar uppsetta hamborgara menu takkann (menu_button)

      // Sýnir allar línur þannig að hægt sé að scrolla í þeim til hægri/vinstri
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Flokkavalið (Allar vörur, Konur, Karlar, Börn)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Consumer<CategoryProvider>(
                builder: (context, catProvider, child) {
                  return CategoryRow(
                    selectedCategoryId: catProvider.selectedCategoryId ?? '',
                    onCategorySelected: (catId) {
                      // Flokkur uppfærður í catProvider þegar valið er flokk og farið á ProductsScreen
                      catProvider.updateCategory(catId.isEmpty ? null : catId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductsScreen(initialCategory: catId.isEmpty ? null : catId),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 18),

            // Láréttur listi af vinsælum vörum
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Text(
                'Vinsælar vörur',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 320,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularItems.length,
                itemBuilder: (context, index) {
                  final product = popularItems[index];
                  return SizedBox(
                    width: 260,
                    child: ProductCard(product: product),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            _buildCategoryRow(context, 'Konur', category1Items),
            const SizedBox(height: 20),
            _buildCategoryRow(context, 'Karlar', category2Items),
            const SizedBox(height: 20),
            _buildCategoryRow(context, 'Börn', category3Items),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Hjálparfall til að búa til röð fyrir hvern flokk
  Widget _buildCategoryRow(
      BuildContext context,
      String categoryTitle,
      List<Product> items,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            categoryTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 8),
        // Láréttur listi fyrir vörur í viðeigandi flokki
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              return SizedBox(
                width: 260,
                child: ProductCard(product: product),
              );
            },
          ),
        ),
      ],
    );
  }
}
