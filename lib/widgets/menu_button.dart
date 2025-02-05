import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:website/data/categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/pages/home_page.dart';
import 'package:website/pages/products_page.dart';
import 'package:website/providers/category_provider.dart';

// Þetta er valmynd sem birtist vinstra megin á skjánum þegar notandi ýtir á menu-hnappinn.

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Sækir categoryProvider til að vita hvaða flokkur/undirflokkur er valinn
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final currentCategoryId = categoryProvider.selectedCategoryId;
    final currentSubcategoryId = categoryProvider.selectedSubcategory;

    // Reiknar hlutföll skjás til að skala boxið rétt.
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const double baseWidth = 1920;
    const double baseHeight = 1080;
    final double widthRatio = screenWidth / baseWidth;
    final double heightRatio = screenHeight / baseHeight;
    final double leftMargin = 80 * widthRatio;
    final double topMargin = 80 * heightRatio;
    final double rightMargin = 1000 * widthRatio;
    final double bottomMargin = 250 * heightRatio;

    void navigateHome(BuildContext context) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
      );
      final catProv = Provider.of<CategoryProvider>(context, listen: false);
      catProv.updateCategory(null);
      catProv.updateSubcategory(null);
    }

    return Container(
      margin: EdgeInsets.fromLTRB(leftMargin, topMargin, rightMargin, bottomMargin),
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Stílaður header efst í valmynd, í anda app bar
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(200, 69, 69, 69),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Center(
              child: TextButton(
                onPressed: () => navigateHome(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                ),
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

          // Flokkar birtast í láréttri röð
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  final isSelected = category['categoryId'] == currentCategoryId;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isSelected ? Colors.grey : Colors.white,
                        foregroundColor:
                        isSelected ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                      categoryProvider.updateCategory(category['categoryId']);
                    },
                      child: Text(category['label']),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Undirflokkar birtast í lóðrétti röð
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 56.0),
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    (currentSubcategoryId == 'Allar vörur')
                        ? Colors.grey
                        : Colors.white,
                    foregroundColor:
                    (currentSubcategoryId == 'Allar vörur')
                        ? Colors.white
                        : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    categoryProvider.updateSubcategory('Allar vörur');
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductsScreen(
                          initialCategory: categoryProvider.selectedCategoryId ?? '0',
                          initialSubcategory: 'Allar vörur',
                        ),
                      ),
                    );
                  },
                  child: const Text('Allar vörur'),
                ),

                const SizedBox(height: 8),

                ...subcategories.map((subcategory) {
                  final isSelected = subcategory == currentSubcategoryId;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.grey : Colors.white,
                        foregroundColor: isSelected ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        categoryProvider.updateSubcategory(subcategory);
                        Navigator.pop(context);

                        final currentCat = categoryProvider.selectedCategoryId;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductsScreen(
                              initialCategory: currentCat,
                            ),
                          ),
                        );
                      },
                      child: Text(_capitalize(subcategory)),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
