import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_constants.dart';

class AppRadius {
  static const double card = 28.0;
  static const double button = 99.0;
  static const double pill = 99.0;

  static final BorderRadius cardBorderRadius = BorderRadius.circular(card);
  static final BorderRadius buttonBorderRadius = BorderRadius.circular(button);
  static final BorderRadius pillBorderRadius = BorderRadius.circular(pill);
}

class AppTheme {
  // Palette constants exposed directly as requested
  static const Color lime = AppColors.lime;
  static const Color ink = AppColors.ink;
  static const Color bg = AppColors.bg;
  static const Color card = AppColors.card;
  static const Color lilac = AppColors.lilac;
  static const Color peach = AppColors.peach;
  static const Color sky = AppColors.sky;
  static const Color coral = AppColors.coral;
  static const Color muted = AppColors.muted;

  // Border radius constants (cards = 28px, buttons = 99px, pills = 99px)
  static const double cardRadius = 28.0;
  static const double buttonRadius = 99.0;
  static const double pillRadius = 99.0;

  static final BorderRadius cardsBorderRadius = BorderRadius.circular(cardRadius);
  static final BorderRadius buttonsBorderRadius = BorderRadius.circular(buttonRadius);
  static final BorderRadius pillsBorderRadius = BorderRadius.circular(pillRadius);

  // Light ThemeData
  static ThemeData get lightTheme {
    final baseTextTheme = ThemeData.light().textTheme;
    final googleTextTheme = GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bg,
      cardColor: AppColors.card,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lime,
        onPrimary: AppColors.ink,
        surface: AppColors.card,
        onSurface: AppColors.ink,
        error: AppColors.coral,
        onError: Colors.white,
        secondary: AppColors.lilac,
        tertiary: AppColors.peach,
      ),
      textTheme: googleTextTheme,
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: cardsBorderRadius,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: buttonsBorderRadius,
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
        ),
      ),
    );
  }

  // Dark ThemeData
  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    final googleTextTheme = GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).apply(
      bodyColor: AppColors.darkInk,
      displayColor: AppColors.darkInk,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      cardColor: AppColors.darkCard,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.lime,
        onPrimary: AppColors.ink,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkInk,
        error: AppColors.coral,
        onError: Colors.white,
        secondary: AppColors.lilac,
        tertiary: AppColors.peach,
      ),
      textTheme: googleTextTheme,
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: cardsBorderRadius,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkInk,
          foregroundColor: AppColors.ink,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: buttonsBorderRadius,
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
        ),
      ),
    );
  }
}
