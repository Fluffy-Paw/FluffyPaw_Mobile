import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: Color(0xFFF9F5F6),
      primaryColor: Color(0xFFF6C8E1),
      hintColor: Color(0xFF838383),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
        displayMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF000000)),
        bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF838383)),
        labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1B1B1B)),
      ),
      iconTheme: IconThemeData(color: Color(0xFF838383)),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 13.9),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        buttonColor: Color(0xFFF6C8E1),
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
