import 'package:flutter/material.dart';

/// Design Token: Border Radius
/// Definiert alle Rundungen
class AppRadius {
  AppRadius._();

  // ============================================================================
  // RADIUS VALUES
  // ============================================================================
  
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0; // Fully rounded
  
  // ============================================================================
  // BORDER RADIUS
  // ============================================================================
  
  static const BorderRadius radiusNone = BorderRadius.zero;
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(full));
  
  // ============================================================================
  // COMPONENT SPECIFIC RADIUS
  // ============================================================================
  
  // Button
  static const BorderRadius buttonRadius = radiusSm;
  
  // Card
  static const BorderRadius cardRadius = radiusMd;
  
  // Input Field
  static const BorderRadius inputRadius = radiusSm;
  
  // Dialog
  static const BorderRadius dialogRadius = radiusLg;
  
  // Avatar
  static const BorderRadius avatarRadius = radiusFull;
  
  // Chip/Badge
  static const BorderRadius chipRadius = radiusFull;
}
