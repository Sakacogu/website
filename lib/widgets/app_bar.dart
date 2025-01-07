import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:website/pages/home_screen.dart';
import 'package:website/pages/cart_page.dart';
import 'package:website/providers/cart_provider.dart';
import 'package:website/providers/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AppBar(
      centerTitle: true,
      toolbarHeight: toolbarHeight,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Leita að vöru',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.inverseSurface,
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
          child: Text('Log in',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary
              ),
          ),
        ),
        const SizedBox(width: 8),

        IconButton(
          icon: Icon(
            themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            themeProvider.toggleTheme();
          },
          tooltip: 'Toggle Dark Mode',
        ),
        const SizedBox(width: 8),

        Consumer<CartProvider>(
          builder: (_, cart, __) => Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                color: Theme.of(context).colorScheme.onPrimary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
                tooltip: 'Skoða körfu',
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: -1,
                  top: -1,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cart.items.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        IconButton(
          icon: const Icon(Icons.favorite_border),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {},
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
