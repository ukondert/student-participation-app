# Phase 4: Organism Components 🦠

## 📋 Übersicht

**Dauer**: 5-6 Tage  
**Risiko**: Mittel-Hoch  
**Abhängigkeiten**: Phase 3 (Molecular Components)  
**Status**: Wartet auf Phase 3 Completion

---

## 🎯 Ziele

1. Aufbau **komplexer, wiederverwendbarer Komponenten**
2. Integration von **State Management** in Organisms
3. **Integration Tests** für komplexe Interaktionen
4. **Performance Optimierung** für Listen

---

## 📊 Komponenten-Inventar

### Lists
- **StudentList**: Scrollbare Liste mit StudentCards
- **SubjectList**: Subject Cards mit Filtering
- **ClassList**: Class Cards Grid/List
- **ParticipationList**: Participation History

### Forms
- **StudentForm**: Vollständiges Student Formular
- **SubjectForm**: Subject Creation/Edit Form
- **ClassForm**: Class Management Form

### Headers
- **AppBarHeader**: Wiederverwendbare AppBar
- **ScreenHeader**: Page Header mit Title + Actions
- **SectionHeader**: Section Divider mit Title

### Navigation
- **BottomNavigation**: Bottom Navigation Bar
- **AppDrawer**: Navigation Drawer
- **TabNavigation**: Tab Bar Navigation

### Dialogs
- **ConfirmDialog**: Confirmation Dialog
- **ExportDialog**: Export Options Dialog
- **FilterDialog**: Filter Selection Dialog

---

## 🏗️ Verzeichnisstruktur

```
lib/presentation/organisms/
├── lists/
│   ├── student_list.dart
│   ├── subject_list.dart
│   ├── class_list.dart
│   └── participation_list.dart
├── forms/
│   ├── student_form.dart
│   ├── subject_form.dart
│   └── class_form.dart
├── headers/
│   ├── app_bar_header.dart
│   ├── screen_header.dart
│   └── section_header.dart
├── navigation/
│   ├── bottom_navigation.dart
│   ├── app_drawer.dart
│   └── tab_navigation.dart
└── dialogs/
    ├── confirm_dialog.dart
    ├── export_dialog.dart
    └── filter_dialog.dart
```

---

## 📝 Schlüssel-Komponenten

### StudentList Organism

```dart
class StudentList extends ConsumerWidget {
  final int classId;
  final bool showParticipationCounts;
  final void Function(Student)? onStudentTap;
  final void Function(Student)? onStudentLongPress;

  const StudentList({
    super.key,
    required this.classId,
    this.showParticipationCounts = true,
    this.onStudentTap,
    this.onStudentLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(
      classRepositoryProvider.select((repo) => repo.watchStudents(classId))
    );

    return StreamBuilder<List<Student>>(
      stream: studentsAsync,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorState(
            message: 'Fehler beim Laden der Schüler',
            onRetry: () => ref.refresh(classRepositoryProvider),
          );
        }

        if (!snapshot.hasData) {
          return LoadingState(message: 'Schüler werden geladen...');
        }

        final students = snapshot.data!;

        if (students.isEmpty) {
          return EmptyState(
            icon: Icons.school,
            title: 'Keine Schüler',
            message: 'Fügen Sie Ihren ersten Schüler hinzu',
            actionLabel: 'Schüler hinzufügen',
            onAction: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudentFormScreen(classId: classId),
              ),
            ),
          );
        }

        return ListView.separated(
          itemCount: students.length,
          separatorBuilder: (_, __) => Divider(height: 1),
          itemBuilder: (context, index) {
            final student = students[index];
            
            // Get participation counts if needed
            final positiveCount = showParticipationCounts
                ? ref.watch(positiveParticipationCountProvider(student.id))
                : 0;
            final negativeCount = showParticipationCounts
                ? ref.watch(negativeParticipationCountProvider(student.id))
                : 0;

            return StudentCard(
              student: student,
              positiveCount: positiveCount,
              negativeCount: negativeCount,
              showCounters: showParticipationCounts,
              onTap: () => onStudentTap?.call(student),
              onLongPress: () => onStudentLongPress?.call(student),
            );
          },
        );
      },
    );
  }
}
```

### StudentForm Organism

```dart
class StudentForm extends StatefulWidget {
  final Student? student; // null for create, Student for edit
  final int classId;

  const StudentForm({
    super.key,
    this.student,
    required this.classId,
  });

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  String? _photoPath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.student?.firstName ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.student?.lastName ?? '',
    );
    _photoPath = widget.student?.photo;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PhotoPickerField(
            label: 'Foto',
            imagePath: _photoPath,
            onImagePicked: (path) => setState(() => _photoPath = path),
          ),
          SizedBox(height: AppSpacing.md),
          
          LabeledTextField(
            label: 'Vorname',
            controller: _firstNameController,
            required: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte Vornamen eingeben';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.md),
          
          LabeledTextField(
            label: 'Nachname',
            controller: _lastNameController,
            required: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte Nachnamen eingeben';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.xl),
          
          PrimaryButton(
            label: widget.student == null ? 'Erstellen' : 'Speichern',
            onPressed: _isLoading ? null : _handleSubmit,
            isLoading: _isLoading,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Save logic here
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
```

### BottomNavigation Organism

```dart
class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Klassen',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Fächer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Protokoll',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.file_download),
          label: 'Export',
        ),
      ],
    );
  }
}
```

---

## ✅ Verification Plan

### Automated Tests

1. **Integration Tests**
   - Organisms integrieren Molecules korrekt
   - State Management funktioniert
   - Error Handling

2. **Performance Tests**
   - Listen mit 100+ Items
   - Scroll Performance
   - Memory Usage

3. **Accessibility Tests**
   - Navigation mit Keyboard
   - Screen Reader Support

### Manual Verification

1. **Functional Testing**
   - Alle Organisms funktionieren standalone
   - State Updates korrekt
   - Error States werden angezeigt

2. **Performance Check**
   - Smooth Scrolling
   - Keine Jank
   - Fast Rendering

---

## 📋 Implementation Checklist

### Lists (Tag 1-2)
- [ ] Implement `student_list.dart` + tests
- [ ] Implement `subject_list.dart` + tests
- [ ] Implement `class_list.dart` + tests
- [ ] Implement `participation_list.dart` + tests

### Forms (Tag 3-4)
- [ ] Implement `student_form.dart` + tests
- [ ] Implement `subject_form.dart` + tests
- [ ] Implement `class_form.dart` + tests

### Headers & Navigation (Tag 4-5)
- [ ] Implement `app_bar_header.dart` + tests
- [ ] Implement `screen_header.dart` + tests
- [ ] Implement `bottom_navigation.dart` + tests
- [ ] Implement `app_drawer.dart` + tests

### Dialogs (Tag 5-6)
- [ ] Implement `confirm_dialog.dart` + tests
- [ ] Implement `export_dialog.dart` + tests
- [ ] Implement `filter_dialog.dart` + tests

### Testing & Optimization
- [ ] Integration tests
- [ ] Performance optimization
- [ ] Code review

---

## 🎯 Success Criteria

- ✅ Alle Organisms implementiert
- ✅ Test Coverage ≥ 75%
- ✅ Performance Benchmarks erfüllt
- ✅ Integration Tests bestehen
- ✅ Code Review abgeschlossen

---

**Status**: Wartet auf Phase 3 Completion
