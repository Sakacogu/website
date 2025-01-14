import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:website/pages/cart_page.dart';
import 'package:website/pages/favorites_page.dart';
import 'package:website/providers/cart_provider.dart';
import 'package:website/providers/theme_provider.dart';
import 'package:website/pages/home_screen.dart';
import 'package:intl/intl.dart';
import 'package:website/pages/product_detail_page.dart';
import 'package:website/providers/category_provider.dart';

// Sýnir heiti verslunnarinnar "Fatavörubúð" í miðjunni og hnappa hægra/vinstamegin við nafnið
// vinstra megin (Menu til að opna Drawer) og hægra megin (karfa, uppáhald, theme toggle).
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  // preferredSize segir Flutter hversu hár AppBar á að vera.
  // kToolbarHeight er venjulega 56 px
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  OverlayEntry? _searchOverlayEntry;
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();

  void _showSearchOverlay(BuildContext context) {
    if (_searchOverlayEntry != null) return; // Setur leitarsíuna ofar öllu öðru á skjánum

    _searchOverlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _removeSearchOverlay();
        },
        child: Material(
          color: Colors.black54,
          child: Stack(
            children: [
              Positioned(
                top: kToolbarHeight + 10,
                left: 20,
                right: 20,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: const Offset(0.0, kToolbarHeight + 10),
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Leita að vörum...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _removeSearchOverlay();
                                },
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (enter) {
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildSearchResults(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_searchOverlayEntry!);
  }

  void _removeSearchOverlay() {
    _searchOverlayEntry?.remove();
    _searchOverlayEntry = null;
    _searchController.clear();
  }

  Widget _buildSearchResults() {
    final query = _searchController.text.toLowerCase();
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final results = categoryProvider.searchProductsByName(query);

    if (query.isEmpty) {
      return const SizedBox.shrink();
    }

    if (results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Engar vörur fundust.'),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final product = results[index];
          return ListTile(
            leading: Image.network(
              product.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.error),
            ),
            title: Text(product.name),
            subtitle: Text('Verð: ${NumberFormat("#,###").format(product.price)}kr'),
            onTap: () {
              _removeSearchOverlay();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }

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

      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Menu Button
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: 'Opna menu',
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              constraints: const BoxConstraints(),
            ),
          ),

          // Stækkunarglerið sem opnar leitarsíuna
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchOverlay(context);
            },
            padding: EdgeInsets.zero,
            tooltip: 'Leita að vörum',
            constraints: const BoxConstraints(),
          ),
        ],
      ),

      // actions er svæðið hægra megin (hnappar til að skipta þema, karfan, hjartað).
      actions: [
        // Log in takki sem á eftir að tengja
        TextButton(
          onPressed: () {},
          child: Text('Log in',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary
            ),
          ),
        ),
        const SizedBox(width: 8),

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
                  MaterialPageRoute(builder: (_) => CartPage()),
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

  @override
  void dispose() {
    _searchController.dispose();
    _removeSearchOverlay();
    super.dispose();
  }
}
