import 'package:flutter/material.dart';
import 'package:website/data/categories.dart';

// Birtir flokka (Allar vörur, Konur, Karlar, Börn) í einni röð undir app bar.
// Birtist lika í menu.
// Hnappur fyrir valinn flokk verður litaður.
// onCategorySelected notað til að tilkynna val.

class CategoryRow extends StatelessWidget {
  final String selectedCategoryId;
  final void Function(String) onCategorySelected;

  const CategoryRow({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          bool isSelected = category['categoryId'] == selectedCategoryId;
          return Padding(
            padding: const EdgeInsets.only(right: 0),
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
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              ),
              onPressed: () {
                onCategorySelected(category['categoryId']);
              },
              child: Text(category['label']),
            ),
          );
        }).toList(),
      ),
    );
  }
}
