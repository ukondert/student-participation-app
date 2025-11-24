import 'package:flutter/material.dart';

/// Design Token: Elevation & Shadows
/// Definiert alle Schatten und Erhebungen
class AppElevation {
  AppElevation._();

  // ============================================================================
  // ELEVATION LEVELS
  // ============================================================================
  
  static const double level0 = 0.0;
  static const double level1 = 1.0;
  static const double level2 = 2.0;
  static const double level3 = 4.0;
  static const double level4 = 6.0;
  static const double level5 = 8.0;
  
  // ============================================================================
  // BOX SHADOWS
  // ============================================================================
  
  static const List<BoxShadow> shadowNone = [];
  
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];
  
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];
  
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
  ];
  
  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Color(0x26000000), // 15% black
      offset: Offset(0, 8),
      blurRadius: 16,
    ),
  ];
  
  // ============================================================================
  // COMPONENT SPECIFIC SHADOWS
  // ============================================================================
  
  static const List<BoxShadow> cardShadow = shadowMd;
  static const List<BoxShadow> buttonShadow = shadowSm;
  static const List<BoxShadow> dialogShadow = shadowXl;
  static const List<BoxShadow> appBarShadow = shadowSm;
}
