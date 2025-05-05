import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color green = Color(0xFF43946D);
  static const Color greenDarker = Color(0xff286045);
  static const Color greyBg = Color(0xFFF2F4F5);
  static const Color greyHint = Color(0xFFCECECE);

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
    dividerTheme: const DividerThemeData(
      color: greyHint,
      thickness: 1.0,
      space: 16.0,
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
      backgroundColor: green,
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: GoogleFonts.figtree(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      )
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
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(width: 2.0, color: green),
      ),
      hintStyle: const TextStyle(
        color: Colors.grey,
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
      indicatorColor: green.withValues(alpha: 0.5),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: green,
      linearMinHeight: 8,
      circularTrackColor: Colors.white,
      linearTrackColor: Colors.white,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    textTheme: GoogleFonts.figtreeTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ).copyWith(
      titleLarge: GoogleFonts.figtree(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.figtree(
        fontSize: 14,
        color: Colors.white70,
      ),
    ),
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: green,
      onPrimary: Colors.white,
      secondary: green,
      onSecondary: Colors.white,
      surface: Colors.grey[850],
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: greenDarker,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: greyHint,
      thickness: 1.0,
      space: 16.0,
    ),
    cardTheme: const CardTheme(
      color: Color(0xFF1E1E1E),
      elevation: 4,
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: green,
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: GoogleFonts.figtree(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white24,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 20.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: greyHint),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(width: 2.0, color: green),
      ),
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
    ),
  );
}