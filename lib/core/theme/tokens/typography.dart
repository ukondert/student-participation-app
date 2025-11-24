import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design Token: Typography
/// Definiert alle Textstile der Anwendung
class AppTypography {
  AppTypography._();

  // ============================================================================
  // FONT FAMILIES
  // ============================================================================
  
  static const String fontFamilyPrimary = 'Inter';
  static const String fontFamilySecondary = 'Inter';
  static const String fontFamilyMono = 'RobotoMono';
  
  // ============================================================================
  // FONT WEIGHTS
  // ============================================================================
  
  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  
  // ============================================================================
  // FONT SIZES
  // ============================================================================
  
  static const double sizeXs = 12.0;
  static const double sizeSm = 14.0;
  static const double sizeMd = 16.0;  // Base
  static const double sizeLg = 18.0;
  static const double sizeXl = 20.0;
  static const double size2Xl = 24.0;
  static const double size3Xl = 30.0;
  static const double size4Xl = 36.0;
  static const double size5Xl = 48.0;
  
  // ============================================================================
  // LINE HEIGHTS
  // ============================================================================
  
  static const double lineHeightTight = 1.25;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;
  
  // ============================================================================
  // TEXT STYLES
  // ============================================================================
  
  // Display Styles (Large Headings)
  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: size5Xl,
    fontWeight: weightBold,
    height: lineHeightTight,
  );
  
  static TextStyle displayMedium = GoogleFonts.inter(
    fontSize: size4Xl,
    fontWeight: weightBold,
    height: lineHeightTight,
  );
  
  static TextStyle displaySmall = GoogleFonts.inter(
    fontSize: size3Xl,
    fontWeight: weightBold,
    height: lineHeightTight,
  );
  
  // Heading Styles
  static TextStyle headingLarge = GoogleFonts.inter(
    fontSize: size2Xl,
    fontWeight: weightSemiBold,
    height: lineHeightNormal,
  );
  
  static TextStyle headingMedium = GoogleFonts.inter(
    fontSize: sizeXl,
    fontWeight: weightSemiBold,
    height: lineHeightNormal,
  );
  
  static TextStyle headingSmall = GoogleFonts.inter(
    fontSize: sizeLg,
    fontWeight: weightSemiBold,
    height: lineHeightNormal,
  );
  
  // Body Styles
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: sizeLg,
    fontWeight: weightRegular,
    height: lineHeightNormal,
  );
  
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: sizeMd,
    fontWeight: weightRegular,
    height: lineHeightNormal,
  );
  
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: sizeSm,
    fontWeight: weightRegular,
    height: lineHeightNormal,
  );
  
  // Label Styles (Buttons, Form Labels)
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: sizeMd,
    fontWeight: weightMedium,
    height: lineHeightNormal,
  );
  
  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: sizeSm,
    fontWeight: weightMedium,
    height: lineHeightNormal,
  );
  
  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: sizeXs,
    fontWeight: weightMedium,
    height: lineHeightNormal,
  );
  
  // Caption/Helper Text
  static TextStyle caption = GoogleFonts.inter(
    fontSize: sizeXs,
    fontWeight: weightRegular,
    height: lineHeightNormal,
  );
  
  // Monospace (for codes, numbers)
  static TextStyle mono = GoogleFonts.robotoMono(
    fontSize: sizeSm,
    fontWeight: weightRegular,
    height: lineHeightNormal,
  );
}
