import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/presentation/molecules/states/state_components.dart';
import 'package:student_participation_app/presentation/pages/subjects/subject_list_page.dart';
import 'package:student_participation_app/presentation/providers/providers.dart';

import '../classes/class_test_helpers.dart';

void main() {
  late MockClassRepository mockRepository;

  setUp(() {
    mockRepository = MockClassRepository();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        classRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: const MaterialApp(
        home: SubjectListPage(
          classId: 1,
          className: 'Test Class',
        ),
      ),
    );
  }

  testWidgets('SubjectListPage shows loading state initially', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(LoadingState), findsOneWidget);
    expect(find.text('Lade Fächer...'), findsOneWidget);
  });

  testWidgets('SubjectListPage shows empty state when no subjects', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    mockRepository.emitSubjects([]);
    await tester.pump();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('Keine Fächer vorhanden'), findsOneWidget);
  });

  testWidgets('SubjectListPage shows list of subjects', (tester) async {
    final subjects = [
      Subject(id: 1, name: 'Mathematics', shortName: 'MATH', classId: 1),
      Subject(id: 2, name: 'English', shortName: 'ENG', classId: 1),
    ];

    await tester.pumpWidget(createWidgetUnderTest());
    mockRepository.emitSubjects(subjects);
    await tester.pump();

    expect(find.text('Mathematics'), findsOneWidget);
    expect(find.text('MATH'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('ENG'), findsOneWidget);
  });

  testWidgets('SubjectListPage shows error state', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    mockRepository.emitSubjectsError('Network error');
    await tester.pump();

    expect(find.byType(ErrorState), findsOneWidget);
    expect(find.text('Fehler beim Laden der Fächer'), findsOneWidget);
  });

  testWidgets('SubjectListPage delete subject shows confirmation', (tester) async {
    final subjects = [
      Subject(id: 1, name: 'Mathematics', shortName: 'MATH', classId: 1),
    ];

    await tester.pumpWidget(createWidgetUnderTest());
    mockRepository.emitSubjects(subjects);
    await tester.pump();

    // Open popup menu
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    // Tap delete
    await tester.tap(find.text('Löschen'));
    await tester.pumpAndSettle();

    expect(find.text('Mathematics löschen?'), findsOneWidget);

    // Confirm delete
    await tester.tap(find.text('Löschen'));
    await tester.pumpAndSettle();

    expect(mockRepository.deleteSubjectCallCount, 1);
    expect(mockRepository.lastDeletedSubjectId, 1);
  });
}
