import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:website/providers/cart_provider.dart';
import 'package:website/models/cart_item.dart';
import 'package:website/widgets/app_bar.dart';
import 'package:website/widgets/menu_button.dart';
import 'package:website/pages/home_page.dart';
import 'package:website/providers/category_provider.dart';

// Þetta er síðan sem sýnir innihald körfunnar (CartPage).
// Hér getur notandi séð hvað er í körfunni, breytt magni eða eytt vöru úr körfunni.

class CartPage extends StatelessWidget {
  CartPage({super.key});

  // Stillir útlitið á verðinu
  final NumberFormat priceFormatter = NumberFormat("#,###");

  @override

  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final totalPrice = cart.items.fold(
      0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
    );

    return Scaffold(
      appBar: const MyAppBar(),   // Notar uppsettan app bar (titil línu)
      drawer: const AppDrawer(), // Notar uppsetta hamborgara menu takkann (menu_button)

      body: cart.items.isEmpty
          ? const Center(
        child: Text(
          'Ekkert í körfu.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ListView af körfulínum
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final CartItem item = cart.items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mynd af vörunni
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              item.product.imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 50);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Nafn, stærð og magn
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Stærð: ${item.size}',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Hnappar til að auka/minnka magn
                                Row(
                                  children: [
                                    Text(
                                      'Fjöldi: ',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSecondary,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        cart.decreaseQuantity(item);
                                      },
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSecondary,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        cart.increaseQuantity(item);
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),

                          // Hnappur til að eyða vörum úr körfunni
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  cart.removeItem(item);
                                },
                              ),
                              // Sýnir samtals verð allra vara í körfu
                              Text(
                                '${priceFormatter.format(item.product.price * item.quantity)}kr',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Heildarverð og takki til að ljúka kaupum
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Heildarverð:',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${priceFormatter.format(totalPrice)}kr',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Tæma körfu og fara aftur á upphafssíðu, snackbar sem staðfestir að vörur hafa verið keyptar
                  cart.clearCart();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (Route<dynamic> route) => false,
                  );
                  final catProv = Provider.of<CategoryProvider>(context, listen: false);
                  catProv.updateCategory(null);
                  catProv.updateSubcategory(null);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vörur keyptar!')),

                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Ljúka kaupum'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
