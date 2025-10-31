  import 'package:flutter/material.dart';

  class AppColors {
    // Gradient Colors
    static const Color primaryDark = Color(0xFF0A0A0F);
    static const Color primaryPurple = Color(0xFF6B2FCC);
    static const Color primaryPurpleLight = Color(0xEC4E0781);
    static const Color secondaryPurple = Color(0xFF9D4EDD);
    static const Color accentPurple = Color(0xFFB565F2);
    static const Color lightPurple = Color(0xFFD4A5FF);

    // Background Colors
    static const Color backgroundDark = Color(0xFF0F0F14);
    static const Color cardDark = Color(0xFF1A1A24);
    static const Color cardDarkElevated = Color(0xFF252532);

    // Text Colors
    static const Color textPrimary = Color(0xFFFFFFFF);
    static const Color textSecondary = Color(0xFFB8B8C8);
    static const Color textTertiary = Color(0xFF6E6E80);

    // Accent Colors
    static const Color success = Color(0xFF4CAF50);
    static const Color warning = Color(0xFFFF9800);
    static const Color error = Color(0xFFE74C3C);
    // static const Color info = Color(0xFF2196F3);
    static const Color info = Color(0xFFB565F2);

    // Gradient
    static const LinearGradient primaryGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryDark, primaryPurple, secondaryPurple],
    );

    static const LinearGradient cardGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [cardDark, cardDarkElevated],
    );
  }