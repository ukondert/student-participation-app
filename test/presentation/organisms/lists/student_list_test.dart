import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/presentation/organisms/lists/student_list.dart';

void main() {
  group('StudentList', () {
    final mockStudents = [
      Student(
        id: 1,
        firstName: 'Max',
        lastName: 'Mustermann',
        classId: 1,
        shortCode: 'MM',
      ),
      Student(
        id: 2,
        firstName: 'Anna',
        lastName: 'Schmidt',
        classId: 1,
        shortCode: 'AS',
      ),
    ];

    testWidgets('shows loading state when isLoading is true', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StudentList(
                students: [],
                isLoading: true,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Schüler werden geladen...'), findsOneWidget);
    });

    testWidgets('shows error state when errorMessage is provided',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StudentList(
                students: [],
                errorMessage: 'Test error',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Fehler'), findsOneWidget);
      expect(find.text('Test error'), findsOneWidget);
    });

    testWidgets('shows empty state when students list is empty',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StudentList(
                students: [],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Keine Schüler'), findsOneWidget);
      expect(
        find.text('Fügen Sie Ihren ersten Schüler hinzu'),
        findsOneWidget,
      );
    });

    testWidgets('shows add button in empty state when onAddStudent provided',
        (tester) async {
      var addCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StudentList(
                students: const [],
                onAddStudent: () => addCalled = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Schüler hinzufügen'), findsOneWidget);
      
      await tester.tap(find.text('Schüler hinzufügen'));
      expect(addCalled, isTrue);
    });

    testWidgets('renders list of students', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StudentList(
                students: mockStudents,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Max Mustermann'), findsOneWidget);
      expect(find.text('Anna Schmidt'), findsOneWidget);
    });

    testWidgets('calls onStudentTap when student is tapped', (tester) async {
      Student? tappedStudent;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StudentList(
                students: mockStudents,
                onStudentTap: (student) => tappedStudent = student,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Max Mustermann'));
      expect(tappedStudent?.id, equals(1));
    });

    testWidgets('calls onStudentLongPress when student is long pressed',
        (tester) async {
      Student? longPressedStudent;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StudentList(
                students: mockStudents,
                onStudentLongPress: (student) => longPressedStudent = student,
              ),
            ),
          ),
        ),
      );

      await tester.longPress(find.text('Max Mustermann'));
      expect(longPressedStudent?.id, equals(1));
    });
  });
}
