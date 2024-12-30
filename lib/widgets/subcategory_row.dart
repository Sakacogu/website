import 'package:flutter/material.dart';
import 'package:website/data/categories.dart';

class SubcategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const SubcategoryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
            isSelected ? Colors.grey : Colors.white,
            foregroundColor:
            isSelected ? Colors.white : Colors.black,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

class CategoryRowSubcategory extends StatelessWidget {
  final void Function(String) onSubcategorySelected;
  final String? selectedSubcategory;

  const CategoryRowSubcategory({
    super.key,
    required this.onSubcategorySelected,
    this.selectedSubcategory,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SubcategoryButton(
            label: 'Allar vörur',
            isSelected: selectedSubcategory == null || selectedSubcategory == 'Allar vörur',
            onPressed: () {
              onSubcategorySelected('Allar vörur');
            },
          ),
          ...subcategories.map((subcategory) {
            return SubcategoryButton(
              label: (subcategory),
              isSelected: selectedSubcategory == subcategory,
              onPressed: () {
                onSubcategorySelected(subcategory);
              },
            );
          }),
        ],
      ),
    );
  }
}
