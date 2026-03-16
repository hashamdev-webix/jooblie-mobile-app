import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.lightPrimary,
      scaffoldBackgroundColor: Colors.transparent, 
      cardColor: AppColors.lightCard,
      
      // Update typography to Space Grotesk for display and Inter for body
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(color: AppColors.lightForeground, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.spaceGrotesk(color: AppColors.lightForeground, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.spaceGrotesk(color: AppColors.lightForeground, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.spaceGrotesk(color: AppColors.lightForeground, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.spaceGrotesk(color: AppColors.lightForeground, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.spaceGrotesk(color: AppColors.lightForeground, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.spaceGrotesk(color: AppColors.lightForeground, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: AppColors.lightForeground),
        bodyMedium: GoogleFonts.inter(color: AppColors.lightMutedForeground),
        labelLarge: GoogleFonts.inter(color: AppColors.lightForeground, fontWeight: FontWeight.w600),
      ),
      colorScheme: ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightSecondary,
        surface: AppColors.lightCard,
        error: AppColors.lightError,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightPrimary),
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.lightMutedForeground),
        prefixIconColor: AppColors.lightMutedForeground,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: Colors.transparent,
      cardColor: AppColors.darkCard,
      
      // Update typography to Space Grotesk for display and Inter for body
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(color: AppColors.darkForeground, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.spaceGrotesk(color: AppColors.darkForeground, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.spaceGrotesk(color: AppColors.darkForeground, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.spaceGrotesk(color: AppColors.darkForeground, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.spaceGrotesk(color: AppColors.darkForeground, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.spaceGrotesk(color: AppColors.darkForeground, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.spaceGrotesk(color: AppColors.darkForeground, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: AppColors.darkForeground),
        bodyMedium: GoogleFonts.inter(color: AppColors.darkMutedForeground),
        labelLarge: GoogleFonts.inter(color: AppColors.darkForeground, fontWeight: FontWeight.w600),
      ),
      colorScheme: ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkSecondary,
        surface: AppColors.darkCard,
        error: AppColors.lightError,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkInput,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.darkPrimary),
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.darkMutedForeground),
        prefixIconColor: AppColors.darkMutedForeground,
      ),
    );
  }
}
