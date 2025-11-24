import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/presentation/atoms/buttons/primary_button.dart';
import 'package:student_participation_app/presentation/pages/classes/class_form_page.dart';
import 'package:student_participation_app/presentation/providers/providers.dart';

import 'class_test_helpers.dart';

void main() {
  late MockClassRepository mockRepository;

  setUp(() {
    mockRepository = MockClassRepository();
  });

  Future<void> pumpPage(WidgetTester tester, {SchoolClass? schoolClass}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          classRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: MaterialApp(
          home: ClassFormPage(schoolClass: schoolClass),
        ),
      ),
    );
  }

  testWidgets('ClassFormPage renders all fields', (tester) async {
    await pumpPage(tester);

    expect(find.text('Neue Klasse'), findsOneWidget);
    expect(find.text('Klassenname *'), findsOneWidget);
    expect(find.text('Klassenvorstand (optional)'), findsOneWidget);
    expect(find.text('Raum (optional)'), findsOneWidget);
    expect(find.text('Schuljahr (optional)'), findsOneWidget);
    expect(find.byType(PrimaryButton), findsOneWidget);
  });

  testWidgets('ClassFormPage validates required fields', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(find.text('Bitte Namen eingeben'), findsOneWidget);
    expect(mockRepository.addClassCallCount, 0);
  });

  testWidgets('ClassFormPage adds new class', (tester) async {
    await pumpPage(tester);

    await tester.enterText(find.bySemanticsLabel('Klassenname *'), 'New Class');
    await tester.enterText(find.bySemanticsLabel('Klassenvorstand (optional)'), 'Teacher A');
    
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    expect(mockRepository.addClassCallCount, 1);
    expect(mockRepository.lastAddedName, 'New Class');
  });

  testWidgets('ClassFormPage pre-fills fields for editing', (tester) async {
    final schoolClass = SchoolClass(
      id: 1,
      name: 'Existing Class',
      teacher: 'Old Teacher',
      room: '101',
      schoolYear: '2022',
    );

    await pumpPage(tester, schoolClass: schoolClass);

    expect(find.text('Klasse bearbeiten'), findsOneWidget);
    expect(find.text('Existing Class'), findsOneWidget);
    expect(find.text('Old Teacher'), findsOneWidget);
    expect(find.text('101'), findsOneWidget);
    expect(find.text('2022'), findsOneWidget);
  });

  testWidgets('ClassFormPage updates existing class', (tester) async {
    final schoolClass = SchoolClass(id: 1, name: 'Old Name');
    await pumpPage(tester, schoolClass: schoolClass);

    await tester.enterText(find.bySemanticsLabel('Klassenname *'), 'Updated Name');
    
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    expect(mockRepository.updateClassCallCount, 1);
    expect(mockRepository.lastUpdatedClass?.name, 'Updated Name');
    expect(mockRepository.lastUpdatedClass?.id, 1);
  });
}
