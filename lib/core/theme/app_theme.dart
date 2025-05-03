import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color green = Color(0xFF43946D);
  static const Color greenDarker = Color(0xff286045);
  static const Color greyBg = Color(0xFFF2F4F5);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    textTheme: GoogleFonts.figtreeTextTheme().copyWith(
      titleLarge: GoogleFonts.figtree(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),

      bodyMedium: GoogleFonts.figtree(
        fontSize: 14,
        color: Colors.black54,
      ),
    ),
    scaffoldBackgroundColor: greyBg,
    colorScheme: const ColorScheme.light().copyWith(
      primary: green,
      onPrimary: Colors.white,
      secondary: green,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: green,
      elevation: 0,
      scrolledUnderElevation: 4.0,
      surfaceTintColor: greenDarker,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
      elevation: 4,
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: GoogleFonts.figtree(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 20.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          width: 2.0,
          color: green,
        ),
      ),
      hintStyle: const TextStyle(
        color: Colors.black54,
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: Colors.white,
      unselectedIconTheme: const IconThemeData(
        color: Colors.black54,
        size: 24,
      ),
      unselectedLabelTextStyle: const TextStyle(
        color: Colors.black54,
      ),
      indicatorColor: Colors.blue.withValues(alpha: 0.5),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: green,
      linearMinHeight: 8,
      circularTrackColor: Colors.white,
      linearTrackColor: Colors.white,
    ),
  );
}