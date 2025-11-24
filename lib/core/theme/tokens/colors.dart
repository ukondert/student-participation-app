import 'package:flutter/material.dart';

/// Design Token: Colors
/// Definiert alle Farbwerte der Anwendung
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ============================================================================
  // PRIMITIVE COLORS (Base Palette)
  // ============================================================================
  
  // Primary Colors
  static const Color primaryBase = Color(0xFF2196F3); // Material Blue
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);
  
  // Secondary Colors
  static const Color secondaryBase = Color(0xFFFFC107); // Amber
  static const Color secondaryLight = Color(0xFFFFD54F);
  static const Color secondaryDark = Color(0xFFFFA000);
  
  // Neutral Colors (Grays)
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);
  
  // ============================================================================
  // SEMANTIC COLORS (Contextual)
  // ============================================================================
  
  // Success
  static const Color successBase = Color(0xFF4CAF50); // Green
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);
  
  // Warning
  static const Color warningBase = Color(0xFFFF9800); // Orange
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);
  
  // Error
  static const Color errorBase = Color(0xFFF44336); // Red
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);
  
  // Info
  static const Color infoBase = Color(0xFF2196F3); // Blue
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);
  
  // ============================================================================
  // FUNCTIONAL COLORS (Light Theme)
  // ============================================================================
  
  // Background
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = neutral50;
  static const Color backgroundTertiary = neutral100;
  
  // Surface
  static const Color surfacePrimary = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = neutral50;
  
  // Text
  static const Color textPrimary = neutral900;
  static const Color textSecondary = neutral700;
  static const Color textTertiary = neutral500;
  static const Color textDisabled = neutral400;
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = neutral900;
  
  // Border
  static const Color borderPrimary = neutral300;
  static const Color borderSecondary = neutral200;
  static const Color borderFocus = primaryBase;
  
  // Divider
  static const Color divider = neutral200;
  
  // ============================================================================
  // DARK THEME COLORS (Future)
  // ============================================================================
  
  // Dark Background
  static const Color darkBackgroundPrimary = Color(0xFF121212);
  static const Color darkBackgroundSecondary = Color(0xFF1E1E1E);
  static const Color darkBackgroundTertiary = Color(0xFF2C2C2C);
  
  // Dark Surface
  static const Color darkSurfacePrimary = Color(0xFF1E1E1E);
  static const Color darkSurfaceSecondary = Color(0xFF2C2C2C);
  
  // Dark Text
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = neutral300;
  static const Color darkTextTertiary = neutral500;
  
  // ============================================================================
  // PARTICIPATION SPECIFIC COLORS
  // ============================================================================
  
  // Positive Participation
  static const Color participationPositive = successBase;
  static const Color participationPositiveLight = successLight;
  static const Color participationPositiveDark = successDark;
  
  // Negative Participation
  static const Color participationNegative = errorBase;
  static const Color participationNegativeLight = errorLight;
  static const Color participationNegativeDark = errorDark;
}
