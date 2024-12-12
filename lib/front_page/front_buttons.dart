import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CategoryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: 82,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(4.4),
          backgroundColor: Colors.white70,
          foregroundColor: const Color.fromARGB(255, 69, 69, 69),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 69, 69, 69),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
