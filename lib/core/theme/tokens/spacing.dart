/// Design Token: Spacing
/// Definiert alle Abstände und Größen
class AppSpacing {
  AppSpacing._();

  // ============================================================================
  // SPACING SCALE (8pt Grid System)
  // ============================================================================
  
  static const double xxxs = 2.0;   // 2px
  static const double xxs = 4.0;    // 4px
  static const double xs = 8.0;     // 8px
  static const double sm = 12.0;    // 12px
  static const double md = 16.0;    // 16px (Base)
  static const double lg = 24.0;    // 24px
  static const double xl = 32.0;    // 32px
  static const double xxl = 48.0;   // 48px
  static const double xxxl = 64.0;  // 64px
  
  // ============================================================================
  // SEMANTIC SPACING
  // ============================================================================
  
  // Padding
  static const double paddingXs = xs;
  static const double paddingSm = sm;
  static const double paddingMd = md;
  static const double paddingLg = lg;
  static const double paddingXl = xl;
  
  // Margin
  static const double marginXs = xs;
  static const double marginSm = sm;
  static const double marginMd = md;
  static const double marginLg = lg;
  static const double marginXl = xl;
  
  // Gap (for Flex layouts)
  static const double gapXs = xs;
  static const double gapSm = sm;
  static const double gapMd = md;
  static const double gapLg = lg;
  
  // ============================================================================
  // COMPONENT SPECIFIC SPACING
  // ============================================================================
  
  // Card
  static const double cardPadding = md;
  static const double cardMargin = sm;
  
  // List Item
  static const double listItemPadding = md;
  static const double listItemGap = sm;
  
  // Form Field
  static const double formFieldPadding = md;
  static const double formFieldGap = sm;
  
  // Button
  static const double buttonPaddingHorizontal = lg;
  static const double buttonPaddingVertical = sm;
  
  // Screen
  static const double screenPadding = md;
  static const double screenPaddingHorizontal = md;
  static const double screenPaddingVertical = lg;
  
  // Icon
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
  
  // Avatar
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 64.0;
  static const double avatarSizeXLarge = 96.0;
}
