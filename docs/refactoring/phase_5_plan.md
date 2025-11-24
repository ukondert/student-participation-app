# Phase 5: Templates & Page Refactoring 📄

## 📋 Übersicht

**Dauer**: 6-8 Tage  
**Risiko**: Hoch  
**Abhängigkeiten**: Phase 4 (Organism Components)  
**Status**: Wartet auf Phase 4 Completion

---

## 🎯 Ziele

1. Erstellung **wiederverwendbarer Layout Templates**
2. **Refactoring aller 16 Screens** zu Pages
3. **Reduzierung von Code-Duplikation** um mindestens 40%
4. **E2E Tests** für kritische User Flows
5. **Visual Regression Tests**

---

## 📊 Screen Inventar

### Zu refactorierende Screens (16 total):

#### Class Management
- `class_list_screen.dart` → `pages/classes/class_list_page.dart`
- `class_form_screen.dart` → `pages/classes/class_form_page.dart`

#### Subject Management
- `all_subjects_screen.dart` → `pages/subjects/all_subjects_page.dart`
- `subject_management_screen.dart` → `pages/subjects/subject_management_page.dart`
- `subject_form_screen.dart` → `pages/subjects/subject_form_page.dart`
- `subject_students_screen.dart` → `pages/subjects/subject_students_page.dart`

#### Student Management
- `student_list_screen.dart` → `pages/students/student_list_page.dart`
- `student_form_screen.dart` → `pages/students/student_form_page.dart`
- `student_detail_screen.dart` → `pages/students/student_detail_page.dart`
- `student_participations_screen.dart` → `pages/students/student_participations_page.dart`

#### Protocol
- `protocol_subjects_screen.dart` → `pages/protocol/protocol_subjects_page.dart`
- `protocol_tracking_screen.dart` → `pages/protocol/protocol_tracking_page.dart`

#### Export
- `export_subjects_screen.dart` → `pages/export/export_subjects_page.dart`

#### Settings
- `settings_screen.dart` → `pages/settings/settings_page.dart`

#### Bluetooth
- `bluetooth_transfer_screen.dart` → `pages/bluetooth/bluetooth_transfer_page.dart`

#### Main
- `main_screen.dart` → `pages/main_page.dart`

---

## 🏗️ Template System

### Verzeichnisstruktur

```
lib/presentation/
├── templates/
│   ├── base_page_template.dart
│   ├── list_page_template.dart
│   ├── form_page_template.dart
│   └── detail_page_template.dart
└── pages/
    ├── classes/
    │   ├── class_list_page.dart
    │   └── class_form_page.dart
    ├── subjects/
    │   ├── all_subjects_page.dart
    │   ├── subject_management_page.dart
    │   ├── subject_form_page.dart
    │   └── subject_students_page.dart
    ├── students/
    │   ├── student_list_page.dart
    │   ├── student_form_page.dart
    │   ├── student_detail_page.dart
    │   └── student_participations_page.dart
    ├── protocol/
    │   ├── protocol_subjects_page.dart
    │   └── protocol_tracking_page.dart
    ├── export/
    │   └── export_subjects_page.dart
    ├── settings/
    │   └── settings_page.dart
    ├── bluetooth/
    │   └── bluetooth_transfer_page.dart
    └── main_page.dart
```

---

## 📝 Template-Spezifikationen

### Base Page Template

```dart
/// Base Page Template
/// 
/// Provides standard page structure with AppBar, Body, FAB, BottomNav
class BasePageTemplate extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBottomNavigation;
  final int? currentNavIndex;
  final void Function(int)? onNavTap;
  final bool showBackButton;

  const BasePageTemplate({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showBottomNavigation = false,
    this.currentNavIndex,
    this.onNavTap,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHeader(
        title: title,
        actions: actions,
        showBackButton: showBackButton,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNavigation
          ? BottomNavigation(
              currentIndex: currentNavIndex ?? 0,
              onTap: onNavTap ?? (_) {},
            )
          : null,
    );
  }
}
```

### List Page Template

```dart
/// List Page Template
/// 
/// Standard template for list-based pages
class ListPageTemplate<T> extends StatelessWidget {
  final String title;
  final Widget list;
  final List<Widget>? actions;
  final VoidCallback? onAdd;
  final String? addButtonLabel;
  final bool showBottomNavigation;
  final int? currentNavIndex;
  final void Function(int)? onNavTap;

  const ListPageTemplate({
    super.key,
    required this.title,
    required this.list,
    this.actions,
    this.onAdd,
    this.addButtonLabel,
    this.showBottomNavigation = false,
    this.currentNavIndex,
    this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return BasePageTemplate(
      title: title,
      body: list,
      actions: actions,
      floatingActionButton: onAdd != null
          ? FloatingActionButton(
              onPressed: onAdd,
              child: const Icon(Icons.add),
              tooltip: addButtonLabel ?? 'Hinzufügen',
            )
          : null,
      showBottomNavigation: showBottomNavigation,
      currentNavIndex: currentNavIndex,
      onNavTap: onNavTap,
    );
  }
}
```

### Form Page Template

```dart
/// Form Page Template
/// 
/// Standard template for form-based pages
class FormPageTemplate extends StatelessWidget {
  final String title;
  final Widget form;
  final bool showBottomNavigation;

  const FormPageTemplate({
    super.key,
    required this.title,
    required this.form,
    this.showBottomNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    return BasePageTemplate(
      title: title,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.screenPadding),
        child: form,
      ),
      showBottomNavigation: showBottomNavigation,
    );
  }
}
```

---

## 📝 Beispiel: Refactored Page

### Before (student_list_screen.dart - 107 Zeilen)

```dart
class StudentListScreen extends ConsumerWidget {
  final int classId;
  final int subjectId;
  final String className;
  final String subjectName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsyncValue = ref.watch(...);

    return Scaffold(
      appBar: AppBar(
        title: Text('$className - $subjectName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              // Export logic...
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Student>>(
        stream: studentsAsyncValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data!;

          return StudentListWidget(
            students: students,
            classId: classId,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(...), // 30+ lines
      floatingActionButton: FloatingActionButton(...),
    );
  }
}
```

### After (student_list_page.dart - ~40 Zeilen)

```dart
class StudentListPage extends ConsumerWidget {
  final int classId;
  final int subjectId;
  final String className;
  final String subjectName;

  const StudentListPage({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.className,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListPageTemplate(
      title: '$className - $subjectName',
      list: StudentList(
        classId: classId,
        showParticipationCounts: true,
        onStudentTap: (student) => _navigateToStudent(context, student),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => _exportData(context, ref),
        ),
      ],
      onAdd: () => _addStudent(context),
      addButtonLabel: 'Schüler hinzufügen',
      showBottomNavigation: true,
      currentNavIndex: 0,
      onNavTap: (index) => _handleNavigation(context, index),
    );
  }

  void _navigateToStudent(BuildContext context, Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentDetailPage(student: student),
      ),
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    // Export logic
  }

  void _addStudent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentFormPage(classId: classId),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
```

**Reduktion**: 107 → 40 Zeilen (~62% weniger Code)

---

## 📋 Implementation Checklist

### Templates (Tag 1)
- [ ] Implement `base_page_template.dart`
- [ ] Implement `list_page_template.dart`
- [ ] Implement `form_page_template.dart`
- [ ] Implement `detail_page_template.dart`
- [ ] Tests für Templates

### Class Pages (Tag 2)
- [ ] Refactor `class_list_screen.dart` → `class_list_page.dart`
- [ ] Refactor `class_form_screen.dart` → `class_form_page.dart`
- [ ] E2E Tests

### Subject Pages (Tag 3)
- [ ] Refactor all 4 subject screens
- [ ] E2E Tests

### Student Pages (Tag 4)
- [ ] Refactor all 4 student screens
- [ ] E2E Tests

### Other Pages (Tag 5-6)
- [ ] Refactor protocol screens
- [ ] Refactor export screen
- [ ] Refactor settings screen
- [ ] Refactor bluetooth screen
- [ ] Refactor main screen
- [ ] E2E Tests

### Testing & Cleanup (Tag 7-8)
- [ ] Visual regression tests
- [ ] Performance tests
- [ ] Delete old screen files
- [ ] Update all navigation references
- [ ] Final integration tests
- [ ] Code review

---

## ✅ Verification Plan

### Automated Tests

1. **E2E Tests** für kritische Flows:
   - Student hinzufügen
   - Participation erfassen
   - Export durchführen
   - Navigation zwischen Screens

2. **Visual Regression Tests**
   - Screenshots aller Pages
   - Vergleich mit Baseline

3. **Performance Tests**
   - Page Load Time
   - Navigation Speed

### Manual Verification

1. **Functional Testing**
   - Alle Features funktionieren
   - Navigation korrekt
   - Keine Regressions

2. **UI/UX Review**
   - Konsistentes Look & Feel
   - Smooth Transitions
   - Responsive Design

---

## 🎯 Success Criteria

- ✅ Alle 16 Screens refactored
- ✅ Code-Duplikation reduziert um ≥40%
- ✅ Alle E2E Tests bestehen
- ✅ Visual Regression Tests bestehen
- ✅ Performance nicht verschlechtert
- ✅ Keine funktionalen Regressions

---

**Status**: Wartet auf Phase 4 Completion  
**Risiko**: Hoch - Umfangreiche Änderungen, sorgfältiges Testing erforderlich
