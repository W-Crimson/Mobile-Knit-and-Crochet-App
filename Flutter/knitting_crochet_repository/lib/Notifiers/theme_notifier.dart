import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  bool _isHighContrast = false;

  bool get isHighContrast => _isHighContrast;

  void toggleTheme() {
    _isHighContrast = !_isHighContrast;
    notifyListeners(); // Tells all listening widgets to rebuild
  }
}

// Standard Theme (Example)
final ThemeData defaultTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Color(0xFFE0E0E0), // Light gray
  textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
);

// High Contrast Theme
final ThemeData highContrastTheme = ThemeData(
  brightness: Brightness.light,
  // Use pure white background and pure black foreground for maximum contrast
  primaryColor: Color(0xFF1C304A), // Highly visible accent color
  scaffoldBackgroundColor: Color(0xFF046B99),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Color(0xFFB3EFFF), // Highly visible text color
      fontWeight: FontWeight.bold, // Increase readability
    ),
    titleLarge: TextStyle(color: Color(0xFFB3EFFF),),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color(0xFF1C304A), // High-contrast button color
  ),
);