import 'package:flutter/material.dart';

// Skilgreining á litaskema (ColorScheme) fyrir ljóst þema og dimmt þema.

const kColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color.fromARGB(255, 69, 69, 69),
  onPrimary: Colors.white,
  secondary: Color.fromARGB(255, 235, 235, 235),
  onSecondary: Color.fromARGB(255, 69, 69, 69),
  error: Colors.red,
  onError: Colors.white,
  surface: Colors.white,
  onSurface: Color.fromARGB(255, 15, 15, 15),
  primaryContainer: Color.fromARGB(255, 120, 120, 120),
  onPrimaryContainer: Colors.white,
  secondaryContainer: Color.fromARGB(255, 220, 220, 220),
  onSecondaryContainer: Color.fromARGB(255, 69, 69, 69),
);

const kDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color.fromARGB(255, 69, 69, 69),
  onPrimary: Color.fromARGB(255, 230, 230, 230),
  secondary: Color.fromARGB(255, 200, 200, 200),
  onSecondary: Color.fromARGB(255, 69, 69, 69),
  error: Colors.red,
  onError: Colors.white,
  surface: Color.fromARGB(255, 120, 120, 120),
  onSurface: Color.fromARGB(255, 15, 15, 15),
  primaryContainer: Color.fromARGB(255, 90, 90, 90),
  onPrimaryContainer: Colors.white,
  secondaryContainer: Color.fromARGB(255, 160, 160, 160),
  onSecondaryContainer: Color.fromARGB(255, 69, 69, 69),
);

// lightTheme notar kColorScheme, og darkTheme notar kDarkColorScheme
final ThemeData lightTheme = ThemeData().copyWith(
  colorScheme: kColorScheme,
  scaffoldBackgroundColor: kColorScheme.surface,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kColorScheme.primary,
    foregroundColor: kColorScheme.onPrimary,
  ),
  cardTheme: const CardTheme().copyWith(
    color: kColorScheme.secondaryContainer,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kColorScheme.primaryContainer,
      foregroundColor: kColorScheme.onPrimaryContainer,
    ),
  ),
  textTheme: ThemeData().textTheme.copyWith(
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
      color: kColorScheme.onSecondaryContainer,
      fontSize: 16,
    ),
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: kDarkColorScheme,
  scaffoldBackgroundColor: kDarkColorScheme.surface,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kDarkColorScheme.primary,
    foregroundColor: kDarkColorScheme.onPrimary,
  ),
  cardTheme: const CardTheme().copyWith(
    color: kDarkColorScheme.secondaryContainer,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kDarkColorScheme.primaryContainer,
      foregroundColor: kDarkColorScheme.onPrimaryContainer,
    ),
  ),
  textTheme: ThemeData.dark().textTheme.copyWith(
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
      color: kDarkColorScheme.onSecondaryContainer,
      fontSize: 16,
    ),
  ),
);
