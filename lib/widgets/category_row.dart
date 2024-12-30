import 'package:flutter/material.dart';
import 'package:website/data/categories.dart';

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
                backgroundColor:
                isSelected ? Colors.grey : Colors.white,
                foregroundColor:
                isSelected ? Colors.white : Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
          side: BorderSide(
            color:
          isSelected ? Colors.grey : Colors.white,
          ),
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
