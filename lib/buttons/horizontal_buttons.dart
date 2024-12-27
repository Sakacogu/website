import 'package:flutter/material.dart';
import 'front_buttons.dart';
import '../data/categories.dart';

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
            padding: const EdgeInsets.only(right: 8.0),
            child: CategoryButton(
              label: category['label'],
              isSelected: isSelected,
              onPressed: () {
                onCategorySelected(category['categoryId']);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
