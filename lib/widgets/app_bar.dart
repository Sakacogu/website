import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:website/pages/cart_page.dart';
import 'package:website/pages/favorites_page.dart';
import 'package:website/providers/cart_provider.dart';
import 'package:website/providers/theme_provider.dart';
import 'package:website/pages/home_page.dart';
import 'package:intl/intl.dart';
import 'package:website/pages/product_detail_page.dart';
import 'package:website/providers/category_provider.dart';

// Sýnir heiti verslunnarinnar "Fatavörubúð" í miðjunni og hnappa hægra/vinstamegin við nafnið
// Vinstra megin (Menu til að opna Drawer og leitar sía) og hægra megin (karfa, uppáhald, theme toggle).
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  // preferredSize segir Flutter hversu hár AppBar á að vera.
  // kToolbarHeight er venjulega 56 px
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  MyAppBarState createState() => MyAppBarState();
}

class MyAppBarState extends State<MyAppBar> {
  OverlayEntry? _searchOverlayEntry;
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();

  void _showSearchOverlay(BuildContext context) {
    if (_searchOverlayEntry != null) return; // Sýnir leitarsíuna

    _searchOverlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _removeSearchOverlay();
        },
        child: Material(
          color: Colors.black54, // Semi-gagnsær bakgrunnur
          child: SafeArea(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0.0, kToolbarHeight + 10.0), // Setur leitarsíuna neðan við appbarinn
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8, // Leitarsía 80% af skjástærð
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Sér þema fyrir leitarsíuna
                      TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                        cursorColor: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSecondaryContainer,
                        decoration: InputDecoration(
                          hintText: 'Leita að vörum...',
                          hintStyle: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                                : Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.6),
                          ),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _removeSearchOverlay();
                            },
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {}); // Endurnýjar leitarniðurstöður
                        },
                      ),
                      const SizedBox(height: 10),
                      // Leitarniðurstöður
                      _buildSearchResults(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Passar að leitin birtist ofar öllu öðru
    Overlay.of(context).insert(_searchOverlayEntry!);
  }

  // Lokar leitarsíunni
  void _removeSearchOverlay() {
    _searchOverlayEntry?.remove();
    _searchOverlayEntry = null;
    _searchController.clear();
  }

  // Setur saman leitarniðurstöður
  Widget _buildSearchResults() {
    final query = _searchController.text.toLowerCase();
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final results = categoryProvider.searchProductsByName(query);

    if (query.isEmpty) {
      return const SizedBox.shrink(); // Engin leit framkvæmd
    }

    if (results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Engar vörur fundust.'),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4, // 40% af hæð skjás
      ),
      child: ListView.builder(
        shrinkWrap: true,
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
              final catProv = Provider.of<CategoryProvider>(context, listen: false);
              catProv.updateCategory(null);
              catProv.updateSubcategory(null);
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

    void navigateHome(BuildContext context) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
      );
      final catProv = Provider.of<CategoryProvider>(context, listen: false);
      catProv.updateCategory(null);
      catProv.updateSubcategory(null);
    }

    return AppBar(
      centerTitle: true,
      title: TextButton(
        onPressed: () => navigateHome(context),
        child: Text(
          'Fatavörubúð',
          style: GoogleFonts.besley(
            color: Colors.white,
            fontSize: 24,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),

      // Leading sér um atriðin vinstramegin á app barinu
      leading: Row(
        children: [
          // Menu takkinn innan í Builder til að ná tveimur tökkum saman vinstramegin á app barinu
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
          CompositedTransformTarget(
            link: _layerLink,
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _showSearchOverlay(context);
              },
              tooltip: 'Leita að vörum',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(), // Passa að þetta taki ekki of mikið pláss
            ),
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
