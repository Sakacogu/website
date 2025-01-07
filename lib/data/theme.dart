import 'package:flutter/material.dart';

const kColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color.fromARGB(255, 69, 69, 69),
  onPrimary: Colors.white,
  primaryContainer: Color.fromARGB(255, 30, 40, 105),
  onPrimaryContainer: Colors.white,
  secondary: Colors.white,
  onSecondary: Color.fromARGB(255, 69, 69, 69),
  secondaryContainer: Colors.white60,
  onSecondaryContainer: Color.fromARGB(255, 69, 69, 69),
  tertiary: Color.fromARGB(255, 120, 69, 69),
  onTertiary: Colors.grey,
  tertiaryContainer: Color.fromARGB(205, 120, 69, 69),
  onTertiaryContainer: Colors.white,
  error: Colors.red,
  onError: Colors.white,
  errorContainer: Color.fromARGB(255, 255, 20, 50),
  onErrorContainer: Colors.white,
  surface: Colors.white,
  onSurface: Color.fromARGB(255, 15, 15, 15),
  outline: Colors.white,
  onInverseSurface: Colors.grey,
  inverseSurface: Colors.white,
  inversePrimary: Colors.white,
);

const kDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color.fromARGB(255, 69, 69, 69),
  onPrimary: Color.fromARGB(255, 230, 230, 230),
  primaryContainer: Color.fromARGB(255, 30, 40, 105),
  onPrimaryContainer: Colors.white,
  secondary: Colors.white,
  onSecondary: Color.fromARGB(255, 69, 69, 69),
  secondaryContainer: Color.fromARGB(255, 69, 69, 69),
  onSecondaryContainer: Colors.white,
  tertiary: Color.fromARGB(255, 120, 69, 69),
  onTertiary: Colors.black,
  tertiaryContainer: Color.fromARGB(205, 120, 69, 69),
  onTertiaryContainer: Colors.white,
  error: Colors.red,
  onError: Colors.white,
  errorContainer: Color.fromARGB(255, 255, 20, 50),
  onErrorContainer: Colors.white,
  surface: Color.fromARGB(255, 100, 100, 100),
  onSurface: Color.fromARGB(255, 15, 15, 15),
  outline: Colors.white,
  onInverseSurface: Colors.black,
  inverseSurface: Colors.white,
  inversePrimary: Colors.white,
);

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
