import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const CategoryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 4),
          backgroundColor: isSelected ? Colors.blue : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
