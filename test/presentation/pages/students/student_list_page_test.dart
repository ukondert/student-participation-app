import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/presentation/molecules/states/state_components.dart';
import 'package:student_participation_app/presentation/pages/students/student_list_page.dart';
import 'package:student_participation_app/presentation/providers/providers.dart';

import '../classes/class_test_helpers.dart';
import 'student_test_helpers.dart';

void main() {
  late MockClassRepository mockClassRepository;
  late MockParticipationRepository mockParticipationRepository;

  setUp(() {
    mockClassRepository = MockClassRepository();
    mockParticipationRepository = MockParticipationRepository();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        classRepositoryProvider.overrideWithValue(mockClassRepository),
        participationRepositoryProvider.overrideWithValue(mockParticipationRepository),
      ],
      child: const MaterialApp(
        home: StudentListPage(
          classId: 1,
          subjectId: 1,
          className: 'Test Class',
          subjectName: 'Test Subject',
        ),
      ),
    );
  }

  testWidgets('StudentListPage shows loading state initially', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(LoadingState), findsOneWidget);
    expect(find.text('Lade Schüler...'), findsOneWidget);
  });

  testWidgets('StudentListPage shows empty state when no students', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    mockClassRepository.emitStudents([]);
    await tester.pump();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('Keine Schüler vorhanden'), findsOneWidget);
  });

  testWidgets('StudentListPage shows list of students', (tester) async {
    final students = [
      Student(id: 1, firstName: 'John', lastName: 'Doe', shortCode: 'JD', classId: 1),
      Student(id: 2, firstName: 'Jane', lastName: 'Smith', shortCode: 'JS', classId: 1),
    ];

    await tester.pumpWidget(createWidgetUnderTest());
    mockClassRepository.emitStudents(students);
    await tester.pump();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Kürzel: JD'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);
    expect(find.text('Kürzel: JS'), findsOneWidget);
  });

  testWidgets('StudentListPage shows error state', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    mockClassRepository.emitStudentsError('Network error');
    await tester.pump();

    expect(find.byType(ErrorState), findsOneWidget);
    expect(find.text('Fehler beim Laden der Schüler'), findsOneWidget);
  });
}
