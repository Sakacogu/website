import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:website/pages/cart_page.dart';
import 'package:website/pages/favorites_page.dart';
import 'package:website/providers/cart_provider.dart';
import 'package:website/providers/theme_provider.dart';
import 'package:website/pages/home_screen.dart';

// Sýnir heiti verslunnarinnar "Fatavörubúð" í miðjunni og hnappa hægra/vinstamegin við nafnið
// vinstra megin (Menu til að opna Drawer) og hægra megin (karfa, uppáhald, theme toggle).
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  // preferredSize segir Flutter hversu hár AppBar á að vera.
  // kToolbarHeight er venjulega 56 px
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Hér sækjum við Provider fyrir þema og körfu
    final themeProvider = Provider.of<ThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return AppBar(
      centerTitle: true,
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

        TextButton(
          onPressed: () {},
          child: Text('Log in',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary
              ),
          ),
        ),

      actions: [
        // Theme toggle (ljóst vs. dimmt þema)
        IconButton(
          icon: Icon(
            themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          tooltip: 'Skipta um þema',
          onPressed: () => themeProvider.toggleTheme(),
        ),

        // Karfan - sýnir fjölda hluta í körfu ef karfan er ekki tóm
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              tooltip: 'Karfa',
              onPressed: () {
                // Loka snackbar og fara í CartPage
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
            ),
            // Ef karfan er ekki tóm, birtist rautt merki
            if (cartProvider.items.isNotEmpty)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '${cartProvider.items.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),

        // Uppáhalds (favorite)
        IconButton(
          icon: const Icon(Icons.favorite_border),
          tooltip: 'Uppáhalds',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesPage()),
            );
          },
        ),

        // smá bil
        const SizedBox(width: 8),
      ],
    );
  }
}
