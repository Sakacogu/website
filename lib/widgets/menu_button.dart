import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:website/data/categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/providers/category_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final currentCategoryId = categoryProvider.selectedCategoryId;
    final currentSubcategoryId = categoryProvider.selectedSubcategory;

    return Container(
      margin: const EdgeInsets.fromLTRB(80, 80, 1000, 250),
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
    onPressed: (){
      categoryProvider.updateCategory('0');
      Navigator.pop(context);
    },
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

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 56.0),
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    (currentSubcategoryId == null ||
                        currentSubcategoryId == 'Allar vörur')
                        ? Colors.grey
                        : Colors.white,
                    foregroundColor:
                    (currentSubcategoryId == null ||
                        currentSubcategoryId == 'Allar vörur')
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
                    categoryProvider.updateSubcategory(null);
                    Navigator.pop(context);
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
                        backgroundColor:
                        isSelected ? Colors.grey
                        : Colors.white,
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
                        categoryProvider.updateSubcategory(subcategory);
                      },
                      child: Text(_capitalize(subcategory)),
                    ),
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
