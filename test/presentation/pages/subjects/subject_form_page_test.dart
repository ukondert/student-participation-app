import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/presentation/atoms/buttons/primary_button.dart';
import 'package:student_participation_app/presentation/pages/subjects/subject_form_page.dart';
import 'package:student_participation_app/presentation/providers/providers.dart';

import '../classes/class_test_helpers.dart';

void main() {
  late MockClassRepository mockRepository;

  setUp(() {
    mockRepository = MockClassRepository();
  });

  Widget createWidgetUnderTest({Subject? subject}) {
    return ProviderScope(
      overrides: [
        classRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: MaterialApp(
        home: SubjectFormPage(
          classId: 1,
          subject: subject,
        ),
      ),
    );
  }

  testWidgets('SubjectFormPage renders all fields', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Neues Fach'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('Fachname *'), findsOneWidget);
    expect(find.text('Kürzel *'), findsOneWidget);
    expect(find.text('Anmerkungen (optional)'), findsOneWidget);
    expect(find.byType(PrimaryButton), findsOneWidget);
  });

  testWidgets('SubjectFormPage validates required fields', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(find.text('Bitte Namen eingeben'), findsOneWidget);
    expect(find.text('Bitte Kürzel eingeben'), findsOneWidget);
    expect(mockRepository.addSubjectCallCount, 0);
  });

  testWidgets('SubjectFormPage adds new subject', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Fachname *'), 'Mathematics');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Kürzel *'), 'MATH');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Anmerkungen (optional)'), 'Core subject');

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(mockRepository.addSubjectCallCount, 1);
    expect(mockRepository.lastAddedSubjectName, 'Mathematics');
  });

  testWidgets('SubjectFormPage edits existing subject', (tester) async {
    final subject = Subject(
      id: 1,
      name: 'Old Name',
      shortName: 'OLD',
      notes: 'Old Notes',
      classId: 1,
    );

    await tester.pumpWidget(createWidgetUnderTest(subject: subject));

    expect(find.text('Fach bearbeiten'), findsOneWidget);
    expect(find.text('Old Name'), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Fachname *'), 'New Name');
    
    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(mockRepository.updateSubjectCallCount, 1);
    expect(mockRepository.lastUpdatedSubject?.name, 'New Name');
    expect(mockRepository.lastUpdatedSubject?.id, 1);
  });
}
