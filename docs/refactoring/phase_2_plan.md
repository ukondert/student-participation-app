# Phase 2: Atomic Components ⚛️

## 📋 Übersicht

**Dauer**: 3-4 Tage  
**Risiko**: Niedrig  
**Abhängigkeiten**: Phase 1 (Design Tokens müssen vorhanden sein)  
**Status**: Wartet auf Phase 1 Completion

---

## 🎯 Ziele

1. Extraktion **atomarer UI-Elemente** aus bestehenden Screens
2. Implementierung **wiederverwendbarer Basis-Komponenten**
3. **Unit Tests** für alle Atomic Components
4. **Storybook/Widgetbook** Integration für visuelle Dokumentation

---

## 📊 Komponenten-Inventar

### Aus bestehenden Screens identifiziert:

#### Buttons
- Primary Button (ElevatedButton)
- Secondary Button (OutlinedButton)
- Text Button
- Icon Button
- Floating Action Button

#### Inputs
- Text Field (Standard Input)
- Number Field
- Search Field
- Checkbox
- Radio Button
- Switch

#### Labels & Text
- Heading Text
- Body Text
- Caption Text
- Badge/Tag
- Label

#### Indicators
- Loading Spinner (CircularProgressIndicator)
- Progress Bar
- Avatar (Student Photo)
- Icon
- Divider

#### Feedback
- Snackbar Content
- Tooltip

---

## 🏗️ Proposed Changes

### Verzeichnisstruktur

```
lib/presentation/atoms/
├── buttons/
│   ├── primary_button.dart
│   ├── secondary_button.dart
│   ├── text_button.dart
│   ├── icon_button.dart
│   └── fab_button.dart
├── inputs/
│   ├── text_input.dart
│   ├── number_input.dart
│   ├── search_input.dart
│   ├── checkbox_input.dart
│   ├── radio_input.dart
│   └── switch_input.dart
├── labels/
│   ├── heading_text.dart
│   ├── body_text.dart
│   ├── caption_text.dart
│   ├── badge.dart
│   └── tag.dart
├── indicators/
│   ├── loading_spinner.dart
│   ├── progress_bar.dart
│   ├── avatar.dart
│   ├── app_icon.dart
│   └── divider.dart
└── feedback/
    ├── snackbar_content.dart
    └── tooltip_wrapper.dart
```

---

## 📝 Komponenten-Spezifikationen

### 1. Buttons

#### Primary Button

**[NEW]** `lib/presentation/atoms/buttons/primary_button.dart`

```dart
import 'package:flutter/material.dart';
import '../../../core/theme/tokens/colors.dart';
import '../../../core/theme/tokens/spacing.dart';
import '../../../core/theme/tokens/typography.dart';
import '../../../core/theme/tokens/radius.dart';

/// Primary action button
/// 
/// Used for main actions in forms and screens.
/// 
/// Example:
/// ```dart
/// PrimaryButton(
///   label: 'Speichern',
///   onPressed: () => save(),
///   isLoading: false,
/// )
/// ```
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBase,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.neutral300,
        disabledForegroundColor: AppColors.textDisabled,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.buttonPaddingHorizontal,
          vertical: AppSpacing.buttonPaddingVertical,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.buttonRadius,
        ),
        minimumSize: const Size(88, 48), // Accessibility: min touch target
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.textOnPrimary,
                ),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppSpacing.iconSizeSmall),
                  SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  label,
                  style: AppTypography.labelLarge,
                ),
              ],
            ),
    );

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
```

**Tests**: `test/presentation/atoms/buttons/primary_button_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/presentation/atoms/buttons/primary_button.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('renders label correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Test',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryButton));
      expect(pressed, isTrue);
    });

    testWidgets('shows loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Test',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test'), findsNothing);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Test',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Test',
              icon: Icons.add,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('is full width when isFullWidth is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Test',
              onPressed: () {},
              isFullWidth: true,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.width, double.infinity);
    });
  });
}
```

#### Weitere Button-Komponenten

Analog zu PrimaryButton erstellen für:
- **SecondaryButton**: OutlinedButton mit Secondary Color
- **TextButton**: Flacher Button ohne Background
- **IconButton**: Nur Icon, quadratisch
- **FABButton**: Floating Action Button Wrapper

---

### 2. Inputs

#### Text Input

**[NEW]** `lib/presentation/atoms/inputs/text_input.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/tokens/colors.dart';
import '../../../core/theme/tokens/spacing.dart';
import '../../../core/theme/tokens/typography.dart';
import '../../../core/theme/tokens/radius.dart';

/// Text input field
/// 
/// Customizable text input with label, hint, error handling.
/// 
/// Example:
/// ```dart
/// TextInput(
///   label: 'Name',
///   hintText: 'Geben Sie Ihren Namen ein',
///   controller: nameController,
///   validator: (value) => value?.isEmpty ?? true ? 'Pflichtfeld' : null,
/// )
/// ```
class TextInput extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool autofocus;

  const TextInput({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          autofocus: autofocus,
          style: AppTypography.bodyMedium,
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: enabled 
                ? AppColors.surfaceSecondary 
                : AppColors.neutral100,
            contentPadding: EdgeInsets.all(AppSpacing.formFieldPadding),
            border: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: BorderSide(color: AppColors.borderPrimary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: BorderSide(color: AppColors.borderPrimary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: BorderSide(
                color: AppColors.borderFocus,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: BorderSide(color: AppColors.errorBase),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: BorderSide(
                color: AppColors.errorBase,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: BorderSide(color: AppColors.borderSecondary),
            ),
          ),
        ),
      ],
    );
  }
}
```

#### Weitere Input-Komponenten

Analog erstellen für:
- **NumberInput**: TextInput mit numeric keyboard
- **SearchInput**: TextInput mit Search Icon
- **CheckboxInput**: Checkbox mit Label
- **RadioInput**: Radio Button mit Label
- **SwitchInput**: Switch mit Label

---

### 3. Labels & Indicators

Erstelle einfache Wrapper-Komponenten für:
- **HeadingText**: Text mit heading style
- **BodyText**: Text mit body style
- **CaptionText**: Text mit caption style
- **Badge**: Kleines farbiges Label
- **Tag**: Chip-ähnliches Element
- **LoadingSpinner**: CircularProgressIndicator Wrapper
- **Avatar**: Runder Avatar mit Fallback
- **AppIcon**: Icon Wrapper mit Size Presets

---

## ✅ Verification Plan

### Automated Tests

Für jede Komponente:

1. **Rendering Tests**
   - Komponente rendert korrekt
   - Props werden korrekt angezeigt
   - Verschiedene States (enabled, disabled, loading, error)

2. **Interaction Tests**
   - Callbacks werden aufgerufen
   - Keyboard Navigation funktioniert
   - Touch Targets sind groß genug (48x48dp)

3. **Accessibility Tests**
   - Semantics sind korrekt
   - Kontrast ist ausreichend
   - Screen Reader Labels vorhanden

### Manual Verification

1. **Widgetbook Review**
   - Alle Komponenten sind sichtbar
   - Alle Varianten sind dokumentiert
   - Interactive Controls funktionieren

2. **Visual Inspection**
   - Design Tokens werden korrekt verwendet
   - Spacing ist konsistent
   - Farben sind korrekt

---

## 📋 Implementation Checklist

### Setup
- [ ] Create `lib/presentation/atoms/` directory structure
- [ ] Create `test/presentation/atoms/` directory structure

### Buttons (Tag 1)
- [ ] Implement `primary_button.dart` + tests
- [ ] Implement `secondary_button.dart` + tests
- [ ] Implement `text_button.dart` + tests
- [ ] Implement `icon_button.dart` + tests
- [ ] Implement `fab_button.dart` + tests
- [ ] Add to Widgetbook

### Inputs (Tag 2)
- [ ] Implement `text_input.dart` + tests
- [ ] Implement `number_input.dart` + tests
- [ ] Implement `search_input.dart` + tests
- [ ] Implement `checkbox_input.dart` + tests
- [ ] Implement `radio_input.dart` + tests
- [ ] Implement `switch_input.dart` + tests
- [ ] Add to Widgetbook

### Labels (Tag 3)
- [ ] Implement `heading_text.dart` + tests
- [ ] Implement `body_text.dart` + tests
- [ ] Implement `caption_text.dart` + tests
- [ ] Implement `badge.dart` + tests
- [ ] Implement `tag.dart` + tests
- [ ] Add to Widgetbook

### Indicators (Tag 3-4)
- [ ] Implement `loading_spinner.dart` + tests
- [ ] Implement `progress_bar.dart` + tests
- [ ] Implement `avatar.dart` + tests
- [ ] Implement `app_icon.dart` + tests
- [ ] Implement `divider.dart` + tests
- [ ] Add to Widgetbook

### Feedback (Tag 4)
- [ ] Implement `snackbar_content.dart` + tests
- [ ] Implement `tooltip_wrapper.dart` + tests
- [ ] Add to Widgetbook

### Documentation & Review
- [ ] Document all components
- [ ] Create usage examples
- [ ] Code review
- [ ] Update design system docs

---

## 🎯 Success Criteria

- ✅ Alle 20+ Atomic Components implementiert
- ✅ Test Coverage ≥ 80% für alle Komponenten
- ✅ Alle Komponenten nutzen Design Tokens
- ✅ Widgetbook zeigt alle Komponenten
- ✅ Accessibility Tests bestehen
- ✅ Keine Compiler Warnings
- ✅ Code Review abgeschlossen

---

## 📝 Deliverables

1. **Code**
   - 20+ Atomic Component Dateien
   - Comprehensive Tests
   - Widgetbook Stories

2. **Documentation**
   - Component API Documentation
   - Usage Examples
   - Accessibility Guidelines

3. **Tests**
   - Unit Tests für alle Komponenten
   - Accessibility Tests
   - Visual Regression Tests (optional)

---

**Status**: Wartet auf Phase 1 Completion  
**Nächster Schritt**: Phase 1 abschließen, dann Phase 2 starten
