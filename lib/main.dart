import 'package:flutter/material.dart';
import 'package:website/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:website/providers/category_provider.dart';
import 'package:website/providers/cart_provider.dart';
import 'package:website/providers/theme_provider.dart';
import 'package:website/data/theme.dart';
import 'package:website/providers/favorites_provider.dart';

// Þetta er aðal inngangspunktur appsins.
// Hann byrjar á "main()" og notar MultiProvider til að binda saman alla Provider-klasa
// eins og CartProvider, CategoryProvider, ThemeProvider, o.s.frv.

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Hver Provider er settur upp hér, t.d. CategoryProvider sem heldur
        // utan um hvaða flokkur er valinn, CartProvider fyrir körfuna osfrv.
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// MyApp er aðal "root" widget appsins.
// Hann notar Consumer á ThemeProvider til að stilla litaþema.
// Svo keyrir hann MaterialApp sem stillir upphafssíðu => HomeScreen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Fatavörubúð',
            // Skoðar themeProvider.themeMode til að sjá hvort appið sé í ljósa eða dimma-þemanu
            themeMode: themeProvider.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const HomeScreen(),
          );
        }
    );
  }
}
