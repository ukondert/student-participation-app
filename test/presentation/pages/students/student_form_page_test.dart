import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/presentation/pages/students/student_form_page.dart';
import 'package:student_participation_app/presentation/providers/providers.dart';

import '../classes/class_test_helpers.dart';

void main() {
  late MockClassRepository mockRepository;

  setUp(() {
    mockRepository = MockClassRepository();
  });

  Widget createWidgetUnderTest({Student? student}) {
    return ProviderScope(
      overrides: [
        classRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: MaterialApp(
        home: StudentFormPage(
          classId: 1,
          student: student,
        ),
      ),
    );
  }

  testWidgets('StudentFormPage renders correctly for new student', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Neuer Schüler'), findsOneWidget);
    expect(find.text('Vorname *'), findsOneWidget);
    expect(find.text('Nachname *'), findsOneWidget);
    expect(find.text('Kürzel (3 Zeichen) *'), findsOneWidget);
    expect(find.text('Speichern'), findsOneWidget);
  });

  testWidgets('StudentFormPage renders correctly for existing student', (tester) async {
    final student = Student(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      shortCode: 'DOE',
      classId: 1,
    );

    await tester.pumpWidget(createWidgetUnderTest(student: student));

    expect(find.text('Schüler bearbeiten'), findsOneWidget);
    expect(find.text('John'), findsOneWidget);
    expect(find.text('Doe'), findsOneWidget);
    expect(find.text('DOE'), findsOneWidget);
    expect(find.text('Protokolleinträge'), findsOneWidget);
  });

  testWidgets('StudentFormPage validates empty fields', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Speichern'));
    await tester.pump();

    expect(find.text('Bitte Vornamen eingeben'), findsOneWidget);
    expect(find.text('Bitte Nachnamen eingeben'), findsOneWidget);
    expect(find.text('Bitte Kürzel eingeben'), findsOneWidget);
  });

  testWidgets('StudentFormPage auto-generates short code', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.widgetWithText(TextFormField, 'Nachname *'), 'Smith');
    await tester.pump();

    expect(find.widgetWithText(TextFormField, 'Kürzel (3 Zeichen) *'), findsOneWidget);
    final shortCodeFinder = find.widgetWithText(TextFormField, 'Kürzel (3 Zeichen) *');
    final shortCodeWidget = tester.widget<TextFormField>(shortCodeFinder);
    expect(shortCodeWidget.controller?.text, 'SMI');
  });

  testWidgets('StudentFormPage adds new student', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.widgetWithText(TextFormField, 'Vorname *'), 'John');
    await tester.enterText(find.widgetWithText(TextFormField, 'Nachname *'), 'Doe');
    // Short code auto-generated to DOE

    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();

    expect(mockRepository.addStudentCallCount, 1);
    expect(mockRepository.lastAddedStudentFirstName, 'John');
  });

  testWidgets('StudentFormPage updates existing student', (tester) async {
    final student = Student(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      shortCode: 'DOE',
      classId: 1,
    );

    await tester.pumpWidget(createWidgetUnderTest(student: student));

    await tester.enterText(find.widgetWithText(TextFormField, 'Vorname *'), 'Jane');
    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();

    expect(mockRepository.updateStudentCallCount, 1);
    expect(mockRepository.lastUpdatedStudent?.firstName, 'Jane');
  });
}
