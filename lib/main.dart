import 'package:flutter/material.dart';
import 'package:website/pages/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:website/providers/category_provider.dart';
import 'package:website/providers/cart_provider.dart';
import 'package:website/providers/theme_provider.dart';
import 'package:website/data/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Fatavörubúð',
            themeMode: themeProvider.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const HomeScreen(),
          );
        }
    );
  }
}
