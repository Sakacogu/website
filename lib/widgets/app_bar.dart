import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/pages/home_screen.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSearch;
  final double toolbarHeight;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;

  const MyAppBar({
    super.key,
    this.showSearch = true,
    this.toolbarHeight = 70.0,
    this.searchController,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: toolbarHeight,
      leadingWidth: showSearch ? 550 : 120,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 30),
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(ctx).openDrawer();
              },
            ),
          ),
          if (showSearch) const SizedBox(width: 50),
          if (showSearch)
            SizedBox(
              width: 310,
              height: 35,
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Hverju ertu að leita að?',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: (searchController != null &&
                      searchController!.text.isNotEmpty)
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController!.clear();
                      onSearchChanged?.call('');
                    },
                  )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
        ],
      ),
      title:
      TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
          );
        },
        child: Text(
          'Fatavörubúð',
          style: GoogleFonts.besley(
            color: Colors.white,
            fontSize: 24,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('Log in', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.dark_mode),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {},
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
