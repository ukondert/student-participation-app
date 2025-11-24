# Design System Documentation

## Übersicht

Dieses Dokument beschreibt das Design System der Schüler-Mitarbeit-Tracker App.

## Design Tokens

Design Tokens sind die grundlegenden Bausteine unseres Design Systems. Sie definieren Farben, Abstände, Typografie und andere visuelle Eigenschaften in einer zentralen, wiederverwendbaren Form.

### Warum Design Tokens?

- ✅ **Konsistenz**: Einheitliches Look & Feel in der gesamten App
- ✅ **Wartbarkeit**: Änderungen an einem Ort wirken sich überall aus
- ✅ **Skalierbarkeit**: Einfaches Hinzufügen neuer Themes (z.B. Dark Mode)
- ✅ **Entwickler-Erfahrung**: Klare, semantische Namen statt Magic Numbers

---

## Colors

Alle Farben sind in `lib/core/theme/tokens/colors.dart` definiert.

### Primitive Colors

Basis-Farbpalette der Anwendung:

#### Primary (Material Blue)
- `AppColors.primaryBase` - #2196F3
- `AppColors.primaryLight` - #64B5F6
- `AppColors.primaryDark` - #1976D2

#### Secondary (Amber)
- `AppColors.secondaryBase` - #FFC107
- `AppColors.secondaryLight` - #FFD54F
- `AppColors.secondaryDark` - #FFA000

#### Neutral (Gray Scale)
- `AppColors.neutral50` bis `AppColors.neutral900`
- Von sehr hell (#FAFAFA) bis sehr dunkel (#212121)

### Semantic Colors

Kontextbezogene Farben für spezifische Zwecke:

#### Success (Grün)
- `AppColors.successBase` - #4CAF50
- `AppColors.successLight` - #81C784
- `AppColors.successDark` - #388E3C

#### Warning (Orange)
- `AppColors.warningBase` - #FF9800
- `AppColors.warningLight` - #FFB74D
- `AppColors.warningDark` - #F57C00

#### Error (Rot)
- `AppColors.errorBase` - #F44336
- `AppColors.errorLight` - #E57373
- `AppColors.errorDark` - #D32F2F

#### Info (Blau)
- `AppColors.infoBase` - #2196F3
- `AppColors.infoLight` - #64B5F6
- `AppColors.infoDark` - #1976D2

### Functional Colors

Farben für spezifische UI-Elemente:

#### Background
- `AppColors.backgroundPrimary` - Haupt-Hintergrund (Weiß)
- `AppColors.backgroundSecondary` - Sekundärer Hintergrund (neutral50)
- `AppColors.backgroundTertiary` - Tertiärer Hintergrund (neutral100)

#### Surface
- `AppColors.surfacePrimary` - Haupt-Oberfläche (Weiß)
- `AppColors.surfaceSecondary` - Sekundäre Oberfläche (neutral50)

#### Text
- `AppColors.textPrimary` - Haupttext (neutral900)
- `AppColors.textSecondary` - Sekundärtext (neutral700)
- `AppColors.textTertiary` - Tertiärtext (neutral500)
- `AppColors.textDisabled` - Deaktivierter Text (neutral400)
- `AppColors.textOnPrimary` - Text auf Primary Color (Weiß)
- `AppColors.textOnSecondary` - Text auf Secondary Color (neutral900)

#### Border
- `AppColors.borderPrimary` - Hauptrahmen (neutral300)
- `AppColors.borderSecondary` - Sekundärrahmen (neutral200)
- `AppColors.borderFocus` - Fokus-Rahmen (primaryBase)

### Participation-Specific Colors

Spezielle Farben für die Mitarbeits-Erfassung:

#### Positive Participation
- `AppColors.participationPositive` - Positive Mitarbeit (successBase)
- `AppColors.participationPositiveLight` - Hell (successLight)
- `AppColors.participationPositiveDark` - Dunkel (successDark)

#### Negative Participation
- `AppColors.participationNegative` - Negative Mitarbeit (errorBase)
- `AppColors.participationNegativeLight` - Hell (errorLight)
- `AppColors.participationNegativeDark` - Dunkel (errorDark)

### Accessibility

Alle Farbkombinationen erfüllen **WCAG 2.1 AA Standards**:
- Normal Text: Mindestens **4.5:1** Kontrastverhältnis
- Large Text (≥18px): Mindestens **3:1** Kontrastverhältnis

---

## Spacing

Basierend auf einem **8pt Grid System**.

Alle Spacing-Werte sind in `lib/core/theme/tokens/spacing.dart` definiert.

### Spacing Scale

- `AppSpacing.xxxs` - 2px
- `AppSpacing.xxs` - 4px
- `AppSpacing.xs` - 8px
- `AppSpacing.sm` - 12px
- `AppSpacing.md` - 16px (Base)
- `AppSpacing.lg` - 24px
- `AppSpacing.xl` - 32px
- `AppSpacing.xxl` - 48px
- `AppSpacing.xxxl` - 64px

### Semantic Spacing

#### Padding
- `AppSpacing.paddingXs` bis `AppSpacing.paddingXl`

#### Margin
- `AppSpacing.marginXs` bis `AppSpacing.marginXl`

#### Gap (für Flex Layouts)
- `AppSpacing.gapXs` bis `AppSpacing.gapLg`

### Component-Specific Spacing

#### Card
- `AppSpacing.cardPadding` - 16px
- `AppSpacing.cardMargin` - 12px

#### List Item
- `AppSpacing.listItemPadding` - 16px
- `AppSpacing.listItemGap` - 12px

#### Form Field
- `AppSpacing.formFieldPadding` - 16px
- `AppSpacing.formFieldGap` - 12px

#### Button
- `AppSpacing.buttonPaddingHorizontal` - 24px
- `AppSpacing.buttonPaddingVertical` - 12px

#### Screen
- `AppSpacing.screenPadding` - 16px
- `AppSpacing.screenPaddingHorizontal` - 16px
- `AppSpacing.screenPaddingVertical` - 24px

### Icon Sizes
- `AppSpacing.iconSizeSmall` - 16px
- `AppSpacing.iconSizeMedium` - 24px
- `AppSpacing.iconSizeLarge` - 32px
- `AppSpacing.iconSizeXLarge` - 48px

### Avatar Sizes
- `AppSpacing.avatarSizeSmall` - 32px
- `AppSpacing.avatarSizeMedium` - 48px
- `AppSpacing.avatarSizeLarge` - 64px
- `AppSpacing.avatarSizeXLarge` - 96px

---

## Typography

Verwendet **Google Fonts (Inter)** für optimale Lesbarkeit.

Alle Text-Styles sind in `lib/core/theme/tokens/typography.dart` definiert.

### Font Families
- Primary: **Inter**
- Secondary: **Inter**
- Monospace: **Roboto Mono**

### Font Weights
- `AppTypography.weightLight` - 300
- `AppTypography.weightRegular` - 400
- `AppTypography.weightMedium` - 500
- `AppTypography.weightSemiBold` - 600
- `AppTypography.weightBold` - 700

### Font Sizes
- `AppTypography.sizeXs` - 12px
- `AppTypography.sizeSm` - 14px
- `AppTypography.sizeMd` - 16px (Base)
- `AppTypography.sizeLg` - 18px
- `AppTypography.sizeXl` - 20px
- `AppTypography.size2Xl` - 24px
- `AppTypography.size3Xl` - 30px
- `AppTypography.size4Xl` - 36px
- `AppTypography.size5Xl` - 48px

### Line Heights
- `AppTypography.lineHeightTight` - 1.25
- `AppTypography.lineHeightNormal` - 1.5
- `AppTypography.lineHeightRelaxed` - 1.75

### Text Styles

#### Display (Large Headings)
- `AppTypography.displayLarge` - 48px, Bold
- `AppTypography.displayMedium` - 36px, Bold
- `AppTypography.displaySmall` - 30px, Bold

#### Heading (Section Headings)
- `AppTypography.headingLarge` - 24px, SemiBold
- `AppTypography.headingMedium` - 20px, SemiBold
- `AppTypography.headingSmall` - 18px, SemiBold

#### Body (Content Text)
- `AppTypography.bodyLarge` - 18px, Regular
- `AppTypography.bodyMedium` - 16px, Regular
- `AppTypography.bodySmall` - 14px, Regular

#### Label (Buttons, Form Labels)
- `AppTypography.labelLarge` - 16px, Medium
- `AppTypography.labelMedium` - 14px, Medium
- `AppTypography.labelSmall` - 12px, Medium

#### Caption (Helper Text)
- `AppTypography.caption` - 12px, Regular

#### Monospace (Codes, Numbers)
- `AppTypography.mono` - 14px, Regular, Roboto Mono

---

## Border Radius

Alle Border Radius Werte sind in `lib/core/theme/tokens/radius.dart` definiert.

### Radius Values
- `AppRadius.none` - 0px
- `AppRadius.xs` - 4px
- `AppRadius.sm` - 8px
- `AppRadius.md` - 12px
- `AppRadius.lg` - 16px
- `AppRadius.xl` - 24px
- `AppRadius.full` - Vollständig rund

### Component-Specific Radius
- `AppRadius.buttonRadius` - 8px (sm)
- `AppRadius.cardRadius` - 12px (md)
- `AppRadius.inputRadius` - 8px (sm)
- `AppRadius.dialogRadius` - 16px (lg)
- `AppRadius.avatarRadius` - Vollständig rund
- `AppRadius.chipRadius` - Vollständig rund

---

## Elevation & Shadows

Alle Elevation-Werte sind in `lib/core/theme/tokens/elevation.dart` definiert.

### Elevation Levels
- `AppElevation.level0` - 0dp (keine Erhebung)
- `AppElevation.level1` - 1dp
- `AppElevation.level2` - 2dp
- `AppElevation.level3` - 4dp
- `AppElevation.level4` - 6dp
- `AppElevation.level5` - 8dp

### Box Shadows
- `AppElevation.shadowNone` - Kein Schatten
- `AppElevation.shadowSm` - Kleiner Schatten
- `AppElevation.shadowMd` - Mittlerer Schatten
- `AppElevation.shadowLg` - Großer Schatten
- `AppElevation.shadowXl` - Extra großer Schatten

### Component-Specific Shadows
- `AppElevation.cardShadow` - Mittlerer Schatten
- `AppElevation.buttonShadow` - Kleiner Schatten
- `AppElevation.dialogShadow` - Extra großer Schatten
- `AppElevation.appBarShadow` - Kleiner Schatten

---

## Usage Guidelines

### Importing Tokens

```dart
import 'package:student_participation_app/core/theme/tokens/colors.dart';
import 'package:student_participation_app/core/theme/tokens/spacing.dart';
import 'package:student_participation_app/core/theme/tokens/typography.dart';
import 'package:student_participation_app/core/theme/tokens/radius.dart';
import 'package:student_participation_app/core/theme/tokens/elevation.dart';
```

### Using Colors

```dart
// ✅ Good
Container(
  color: AppColors.primaryBase,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textOnPrimary),
  ),
)

// ❌ Bad
Container(
  color: Color(0xFF2196F3),
  child: Text(
    'Hello',
    style: TextStyle(color: Colors.white),
  ),
)
```

### Using Spacing

```dart
// ✅ Good
Padding(
  padding: EdgeInsets.all(AppSpacing.md),
  child: Column(
    children: [
      Text('Title'),
      SizedBox(height: AppSpacing.sm),
      Text('Content'),
    ],
  ),
)

// ❌ Bad
Padding(
  padding: EdgeInsets.all(16.0),
  child: Column(
    children: [
      Text('Title'),
      SizedBox(height: 12.0),
      Text('Content'),
    ],
  ),
)
```

### Using Typography

```dart
// ✅ Good
Text(
  'Heading',
  style: AppTypography.headingLarge,
)

Text(
  'Body text',
  style: AppTypography.bodyMedium,
)

// ❌ Bad
Text(
  'Heading',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
)

Text(
  'Body text',
  style: TextStyle(fontSize: 16),
)
```

### Using Border Radius

```dart
// ✅ Good
Container(
  decoration: BoxDecoration(
    color: AppColors.surfacePrimary,
    borderRadius: AppRadius.cardRadius,
  ),
)

// ❌ Bad
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
)
```

---

## Accessibility

### Color Contrast

Alle Farbkombinationen erfüllen WCAG 2.1 AA Standards:
- Normal Text: Mindestens 4.5:1
- Large Text: Mindestens 3:1

### Touch Targets

Minimale Touch Target Größe: **48x48dp**

Alle interaktiven Elemente (Buttons, Links, etc.) sollten mindestens diese Größe haben.

### Screen Reader Support

Verwenden Sie semantische Widgets und fügen Sie bei Bedarf `Semantics` Wrapper hinzu.

---

## Theme System

Das Theme System (`lib/core/theme/app_theme.dart`) verwendet alle Design Tokens.

### Light Theme

```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  // ...
)
```

### Dark Theme (Future)

```dart
MaterialApp(
  darkTheme: AppTheme.darkTheme,
  // ...
)
```

---

## Future Enhancements

- [ ] Dark Mode vollständig implementieren
- [ ] High Contrast Mode
- [ ] Custom Theme Builder
- [ ] Animation Tokens
- [ ] Widgetbook für visuelle Dokumentation

---

**Version**: 1.0.0  
**Erstellt**: 2025-11-23  
**Autor**: Refactoring Team  
**Status**: Phase 1 Complete
