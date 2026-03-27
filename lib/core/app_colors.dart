import 'package:flutter/material.dart';

class AppColors {
  // Using exact values from index.css

  // Helper to convert HSL to Color
  static Color _hsl(double h, double s, double l) =>
      HSLColor.fromAHSL(1.0, h, s / 100, l / 100).toColor();

  // Root / Light Mode
  static final Color primaryColor = Color(0xff3C84F6);
  static final Color lightBackground = _hsl(0, 0, 100);
  static final Color lightForeground = _hsl(222, 47, 11);
  static final Color lightCard = _hsl(0, 0, 100);
  static final Color lightPrimary = _hsl(217, 91, 60);
  static final Color lightSecondary = _hsl(174, 60, 45);
  static final Color lightMuted = _hsl(210, 40, 96);
  static final Color lightMutedForeground = _hsl(215, 20, 45);
  static final Color lightBorder = _hsl(214, 32, 91);
  static final Color lightInput = _hsl(214, 32, 91);
  static final Color lightError = _hsl(0, 84, 60);

  // Dark Mode
  static final Color darkBackground = _hsl(222, 47, 6);
  static final Color darkForeground = _hsl(210, 40, 96);
  static final Color darkCard = _hsl(222, 40, 10);
  static final Color darkPrimary = _hsl(217, 91, 60);
  static final Color darkSecondary = _hsl(174, 60, 45);
  static final Color darkMuted = _hsl(222, 30, 15);
  static final Color darkMutedForeground = _hsl(215, 20, 55);
  static final Color darkBorder = _hsl(222, 30, 18);
  static final Color darkInput = _hsl(222, 30, 18);

  // Gradients (using identical HSL mapped colors)
  static final LinearGradient gradientPrimary = LinearGradient(
    colors: [_hsl(217, 91, 60), _hsl(174, 60, 45)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [0.0, 1.0],
  );

  static final LinearGradient lightGradientCard = LinearGradient(
    colors: [_hsl(0, 0, 98), _hsl(0, 0, 100)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [0.0, 1.0],
  );

  static final LinearGradient darkGradientCard = LinearGradient(
    colors: [_hsl(222, 40, 12), _hsl(222, 40, 8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [0.0, 1.0],
  );

  static final LinearGradient lightGradientBackground = LinearGradient(
    colors: [
      lightBackground,
      _hsl(210, 40, 96),
    ], // slightly muted background end
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient darkGradientBackground = LinearGradient(
    colors: [darkBackground, _hsl(222, 40, 10)], // slightly varied dark end
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static BoxShadow get shadowCardLight => BoxShadow(
    color: Colors.black.withValues(alpha: 0.1),
    blurRadius: 42,
    spreadRadius: 1,
    offset: const Offset(0, 4),
  );

  static BoxShadow get shadowCardDark => BoxShadow(
    color: Colors.black.withValues(alpha: 0.3),
    blurRadius: 32,
    offset: const Offset(0, 8),
  );
}
