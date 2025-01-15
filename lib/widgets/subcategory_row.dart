import 'package:flutter/material.dart';
import 'package:website/data/categories.dart';

// Smá hjálpar-Widget fyrir undirflokka-hnappana.
// Birtist neðan við aðal flokkana og í menu.
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
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
          foregroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}

// Sýnir undirflokka (peysur, skyrtur, buxur...) ásamt "Allar vörur".
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
          // "Allar vörur" takki
          SubcategoryButton(
            label: 'Allar vörur',
            isSelected: selectedSubcategory == null || selectedSubcategory == 'Allar vörur',
            onPressed: () {
              onSubcategorySelected('Allar vörur');
            },
          ),
          // Aðrir undirflokkar (peysur, skyrtur etc.)
          ...subcategories.map((subcategory) {
            return SubcategoryButton(
              label: subcategory,
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
