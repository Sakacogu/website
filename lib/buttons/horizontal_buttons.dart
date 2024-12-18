import 'package:flutter/material.dart';
import 'package:website/buttons/front_buttons.dart';
import 'package:website/data/categories.dart';

class CategoryRow extends StatelessWidget {
  final void Function(String) onCategorySelected;
  const CategoryRow({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CategoryButton(
              label: category['label'],
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

