import 'package:flutter/material.dart';
import 'package:website/data/categories.dart';
import 'package:website/pages/front_page.dart';
import 'package:website/pages/product_pages.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  final String currentCategoryId;
  final String? currentSubcategoryId;
  final Function(String) onCategorySelected;
  final Function(String) onSubcategorySelected;

  const AppDrawer({
    super.key,
    required this.currentCategoryId,
    required this.currentSubcategoryId,
    required this.onCategorySelected,
    required this.onSubcategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB (80, 80, 900, 350),
      decoration: BoxDecoration(
        color: Colors.white,
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
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 69, 69, 69),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18)
              ),
            ),
            child: Center(
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
                        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                        foregroundColor: isSelected ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: () {
                        onCategorySelected(category['categoryId']);
                        Navigator.pop(context);

                        if (category['categoryId'] == '0') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Clothes(initialCategory: category['categoryId']),
                            ),
                          );
                        }
                      },
                      child: Text(category['label']),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16,),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 56.0),
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (currentSubcategoryId == null || currentSubcategoryId == 'All')
                        ? Colors.blue
                        : Colors.grey[300],
                    foregroundColor: (currentSubcategoryId == null || currentSubcategoryId == 'All')
                        ? Colors.white
                        : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () {
                    onSubcategorySelected('All');
                    Navigator.pop(context);
                  },
                  child: const Text('All'),
                ),

                const SizedBox(height: 8),

                ...subcategories.map((subcategory) {
                  final isSelected = subcategory == currentSubcategoryId;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                        foregroundColor: isSelected ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: () {
                        onSubcategorySelected(subcategory);
                        Navigator.pop(context);
                      },
                      child: Text(_capitalize(subcategory)),
                      child: Text(subcategory),
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
  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
