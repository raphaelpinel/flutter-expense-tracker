import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:expense_tracker/widgets/expenses.dart';

final kColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.purple,
  secondary: Colors.amber,
);

final kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 5, 99, 125),
  secondary: Colors.amber,
  brightness: Brightness.dark,
);

void main() async {
  // Lock screen orientation to portrait
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
            // backgroundColor: kDarkColorScheme.onPrimaryContainer,
            // foregroundColor: kDarkColorScheme.secondary,
            ),
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
            textStyle: const TextStyle(fontSize: 16),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
            textStyle: const TextStyle(fontSize: 16),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: ThemeData()
            .textTheme
            .copyWith(
              titleLarge: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              titleMedium: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: kDarkColorScheme.secondary,
              ),
              bodyLarge: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: const TextStyle(fontSize: 16),
            )
            .apply(
                // displayColor: kDarkColorScheme.onPrimary,
                fontFamily: 'Lato'),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.secondary),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondary,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.onSecondary,
            textStyle: const TextStyle(fontSize: 16),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: kColorScheme.onPrimaryContainer,
            textStyle: const TextStyle(fontSize: 16),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: ThemeData()
            .textTheme
            .copyWith(
              titleLarge: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              bodyLarge: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: const TextStyle(fontSize: 16),
            )
            .apply(
                bodyColor: kColorScheme.onPrimaryContainer,
                displayColor: kColorScheme.onPrimaryContainer,
                fontFamily: 'Lato'),
      ),
      themeMode: ThemeMode.system,
      home: const Expenses(),
    ),
  );
}
