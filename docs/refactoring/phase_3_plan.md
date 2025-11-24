# Phase 3: Molecular Components 🧬

## 📋 Übersicht

**Dauer**: 4-5 Tage  
**Risiko**: Mittel  
**Abhängigkeiten**: Phase 2 (Atomic Components müssen vorhanden sein)  
**Status**: Wartet auf Phase 2 Completion

---

## 🎯 Ziele

1. **Kombination von Atoms** zu funktionalen Einheiten
2. Implementierung **wiederverwendbarer Patterns**
3. **Component Tests** mit Integration von Atoms
4. **Storybook/Widgetbook** Stories für alle Molecules

---

## 📊 Komponenten-Inventar

### Aus bestehenden Screens identifiziert:

#### Cards
- **Student Card**: Avatar + Name + Participation Counters
- **Subject Card**: Subject Name + Class + Actions
- **Class Card**: Class Info + Stats
- **Participation Card**: Date + Type + Details

#### List Items
- **Student List Item**: Clickable Student Entry
- **Subject List Item**: Subject mit Class Badge
- **Class List Item**: Class mit Student Count
- **Participation List Item**: Participation Entry

#### Form Fields
- **Labeled Text Field**: Label + TextInput + Error
- **Validated Field**: Field mit Validation Feedback
- **Photo Picker Field**: Label + Image + Pick Button
- **Date Picker Field**: Label + Date Display + Picker

#### Navigation
- **Tab Bar Item**: Icon + Label für Bottom Nav
- **Nav Item**: List Tile für Drawer
- **Breadcrumb**: Navigation Path

#### Search & Filter
- **Search Bar**: Search Input + Filter Button
- **Filter Chip**: Selectable Filter Option

#### State Components
- **Empty State**: Icon + Message + CTA
- **Error State**: Error Icon + Message + Retry
- **Loading State**: Spinner + Message

---

## 🏗️ Proposed Changes

### Verzeichnisstruktur

```
lib/presentation/molecules/
├── cards/
│   ├── student_card.dart
│   ├── subject_card.dart
│   ├── class_card.dart
│   └── participation_card.dart
├── list_items/
│   ├── student_list_item.dart
│   ├── subject_list_item.dart
│   ├── class_list_item.dart
│   └── participation_list_item.dart
├── form_fields/
│   ├── labeled_text_field.dart
│   ├── validated_field.dart
│   ├── photo_picker_field.dart
│   └── date_picker_field.dart
├── navigation/
│   ├── tab_bar_item.dart
│   ├── nav_item.dart
│   └── breadcrumb.dart
├── search/
│   ├── search_bar.dart
│   └── filter_chip.dart
└── states/
    ├── empty_state.dart
    ├── error_state.dart
    └── loading_state.dart
```

---

## 📝 Komponenten-Spezifikationen

### 1. Cards

#### Student Card

**[NEW]** `lib/presentation/molecules/cards/student_card.dart`

```dart
import 'package:flutter/material.dart';
import '../../../domain/entities/entities.dart';
import '../../../core/theme/tokens/colors.dart';
import '../../../core/theme/tokens/spacing.dart';
import '../../../core/theme/tokens/typography.dart';
import '../../../core/theme/tokens/radius.dart';
import '../../atoms/indicators/avatar.dart';
import '../../atoms/labels/body_text.dart';
import '../../atoms/labels/caption_text.dart';
import '../../atoms/labels/badge.dart';

/// Student Card Component
/// 
/// Displays student information with participation counters.
/// 
/// Example:
/// ```dart
/// StudentCard(
///   student: student,
///   positiveCount: 5,
///   negativeCount: 1,
///   onTap: () => navigateToStudent(student),
///   onLongPress: () => showOptions(student),
/// )
/// ```
class StudentCard extends StatelessWidget {
  final Student student;
  final int positiveCount;
  final int negativeCount;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showCounters;

  const StudentCard({
    super.key,
    required this.student,
    this.positiveCount = 0,
    this.negativeCount = 0,
    this.onTap,
    this.onLongPress,
    this.showCounters = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.cardRadius,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: AppRadius.cardRadius,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.cardPadding),
          child: Row(
            children: [
              // Avatar
              Avatar(
                imageUrl: student.photo,
                name: '${student.firstName} ${student.lastName}',
                size: AppSpacing.avatarSizeMedium,
              ),
              SizedBox(width: AppSpacing.md),
              
              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                      '${student.firstName} ${student.lastName}',
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: AppSpacing.xxs),
                    CaptionText(
                      student.shortCode,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              
              // Participation Counters
              if (showCounters) ...[
                SizedBox(width: AppSpacing.sm),
                _buildCounters(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounters() {
    return Row(
      children: [
        if (positiveCount > 0)
          Badge(
            label: '+$positiveCount',
            backgroundColor: AppColors.participationPositive,
            textColor: AppColors.textOnPrimary,
          ),
        if (positiveCount > 0 && negativeCount > 0)
          SizedBox(width: AppSpacing.xs),
        if (negativeCount > 0)
          Badge(
            label: '-$negativeCount',
            backgroundColor: AppColors.participationNegative,
            textColor: AppColors.textOnPrimary,
          ),
      ],
    );
  }
}
```

**Tests**: `test/presentation/molecules/cards/student_card_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/presentation/molecules/cards/student_card.dart';

void main() {
  group('StudentCard', () {
    final testStudent = Student(
      id: 1,
      firstName: 'Max',
      lastName: 'Mustermann',
      shortCode: 'MUS',
      photo: null,
      classId: 1,
    );

    testWidgets('renders student name correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StudentCard(student: testStudent),
          ),
        ),
      );

      expect(find.text('Max Mustermann'), findsOneWidget);
      expect(find.text('MUS'), findsOneWidget);
    });

    testWidgets('shows participation counters when showCounters is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StudentCard(
              student: testStudent,
              positiveCount: 5,
              negativeCount: 2,
              showCounters: true,
            ),
          ),
        ),
      );

      expect(find.text('+5'), findsOneWidget);
      expect(find.text('-2'), findsOneWidget);
    });

    testWidgets('hides counters when showCounters is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StudentCard(
              student: testStudent,
              positiveCount: 5,
              showCounters: false,
            ),
          ),
        ),
      );

      expect(find.text('+5'), findsNothing);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StudentCard(
              student: testStudent,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(StudentCard));
      expect(tapped, isTrue);
    });

    testWidgets('calls onLongPress when long pressed', (tester) async {
      var longPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StudentCard(
              student: testStudent,
              onLongPress: () => longPressed = true,
            ),
          ),
        ),
      );

      await tester.longPress(find.byType(StudentCard));
      expect(longPressed, isTrue);
    });
  });
}
```

#### Weitere Card-Komponenten

Analog erstellen für:
- **SubjectCard**: Subject Info + Class Badge + Actions
- **ClassCard**: Class Info + Student Count + Actions
- **ParticipationCard**: Date + Type Badge + Details

---

### 2. List Items

#### Student List Item

**[NEW]** `lib/presentation/molecules/list_items/student_list_item.dart`

```dart
import 'package:flutter/material.dart';
import '../../../domain/entities/entities.dart';
import '../../../core/theme/tokens/spacing.dart';
import '../../atoms/indicators/avatar.dart';
import '../../atoms/labels/body_text.dart';
import '../../atoms/labels/caption_text.dart';

/// Student List Item
/// 
/// Simplified student entry for lists.
/// 
/// Example:
/// ```dart
/// StudentListItem(
///   student: student,
///   onTap: () => selectStudent(student),
///   trailing: Icon(Icons.chevron_right),
/// )
/// ```
class StudentListItem extends StatelessWidget {
  final Student student;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool selected;

  const StudentListItem({
    super.key,
    required this.student,
    this.onTap,
    this.trailing,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      onTap: onTap,
      leading: Avatar(
        imageUrl: student.photo,
        name: '${student.firstName} ${student.lastName}',
        size: AppSpacing.avatarSizeSmall,
      ),
      title: BodyText('${student.firstName} ${student.lastName}'),
      subtitle: CaptionText(student.shortCode),
      trailing: trailing,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.listItemPadding,
        vertical: AppSpacing.xs,
      ),
    );
  }
}
```

#### Weitere List Item-Komponenten

Analog erstellen für:
- **SubjectListItem**: Subject + Class Info
- **ClassListItem**: Class + Student Count
- **ParticipationListItem**: Participation Entry

---

### 3. Form Fields

#### Labeled Text Field

**[NEW]** `lib/presentation/molecules/form_fields/labeled_text_field.dart`

```dart
import 'package:flutter/material.dart';
import '../../../core/theme/tokens/spacing.dart';
import '../../atoms/inputs/text_input.dart';

/// Labeled Text Field
/// 
/// Text input with integrated label and validation.
/// 
/// Example:
/// ```dart
/// LabeledTextField(
///   label: 'Vorname',
///   controller: firstNameController,
///   validator: (value) => value?.isEmpty ?? true ? 'Pflichtfeld' : null,
///   required: true,
/// )
/// ```
class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final bool required;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;

  const LabeledTextField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.hintText,
    this.required = false,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextInput(
          label: required ? '$label *' : label,
          hintText: hintText,
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
        ),
      ],
    );
  }
}
```

#### Weitere Form Field-Komponenten

Analog erstellen für:
- **ValidatedField**: Field mit Validation Feedback Icons
- **PhotoPickerField**: Image Picker Integration
- **DatePickerField**: Date Picker Integration

---

### 4. State Components

#### Empty State

**[NEW]** `lib/presentation/molecules/states/empty_state.dart`

```dart
import 'package:flutter/material.dart';
import '../../../core/theme/tokens/colors.dart';
import '../../../core/theme/tokens/spacing.dart';
import '../../../core/theme/tokens/typography.dart';
import '../../atoms/labels/heading_text.dart';
import '../../atoms/labels/body_text.dart';
import '../../atoms/buttons/primary_button.dart';

/// Empty State Component
/// 
/// Displays when no data is available.
/// 
/// Example:
/// ```dart
/// EmptyState(
///   icon: Icons.school,
///   title: 'Keine Schüler',
///   message: 'Fügen Sie Ihren ersten Schüler hinzu',
///   actionLabel: 'Schüler hinzufügen',
///   onAction: () => addStudent(),
/// )
/// ```
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.neutral400,
            ),
            SizedBox(height: AppSpacing.lg),
            HeadingText(
              title,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            BodyText(
              message,
              textAlign: TextAlign.center,
              color: AppColors.textSecondary,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                icon: Icons.add,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

#### Weitere State-Komponenten

Analog erstellen für:
- **ErrorState**: Error Display mit Retry
- **LoadingState**: Loading Spinner mit Message

---

## ✅ Verification Plan

### Automated Tests

Für jede Komponente:

1. **Integration Tests**
   - Atoms werden korrekt integriert
   - Props werden an Child-Komponenten weitergegeben
   - State Changes funktionieren

2. **Interaction Tests**
   - Tap/Long Press Events
   - Form Validation
   - State Transitions

3. **Accessibility Tests**
   - Semantic Labels
   - Touch Targets
   - Screen Reader Support

### Manual Verification

1. **Widgetbook Review**
   - Alle Molecules sind dokumentiert
   - Verschiedene States sind sichtbar
   - Interactive Controls funktionieren

2. **Integration Check**
   - Molecules nutzen Atoms korrekt
   - Design Tokens werden verwendet
   - Keine Hardcoded Values

---

## 📋 Implementation Checklist

### Cards (Tag 1-2)
- [ ] Implement `student_card.dart` + tests
- [ ] Implement `subject_card.dart` + tests
- [ ] Implement `class_card.dart` + tests
- [ ] Implement `participation_card.dart` + tests
- [ ] Add to Widgetbook

### List Items (Tag 2)
- [ ] Implement `student_list_item.dart` + tests
- [ ] Implement `subject_list_item.dart` + tests
- [ ] Implement `class_list_item.dart` + tests
- [ ] Implement `participation_list_item.dart` + tests
- [ ] Add to Widgetbook

### Form Fields (Tag 3)
- [ ] Implement `labeled_text_field.dart` + tests
- [ ] Implement `validated_field.dart` + tests
- [ ] Implement `photo_picker_field.dart` + tests
- [ ] Implement `date_picker_field.dart` + tests
- [ ] Add to Widgetbook

### Navigation (Tag 4)
- [ ] Implement `tab_bar_item.dart` + tests
- [ ] Implement `nav_item.dart` + tests
- [ ] Implement `breadcrumb.dart` + tests
- [ ] Add to Widgetbook

### Search & States (Tag 4-5)
- [ ] Implement `search_bar.dart` + tests
- [ ] Implement `filter_chip.dart` + tests
- [ ] Implement `empty_state.dart` + tests
- [ ] Implement `error_state.dart` + tests
- [ ] Implement `loading_state.dart` + tests
- [ ] Add to Widgetbook

### Documentation & Review
- [ ] Document all components
- [ ] Create usage examples
- [ ] Integration tests
- [ ] Code review

---

## 🎯 Success Criteria

- ✅ Alle 15+ Molecular Components implementiert
- ✅ Test Coverage ≥ 80%
- ✅ Alle Molecules nutzen Atoms
- ✅ Widgetbook zeigt alle Molecules
- ✅ Integration Tests bestehen
- ✅ Code Review abgeschlossen

---

**Status**: Wartet auf Phase 2 Completion  
**Nächster Schritt**: Phase 2 abschließen, dann Phase 3 starten
