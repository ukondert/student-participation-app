import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/presentation/pages/students/student_detail_page.dart';
import 'package:student_participation_app/presentation/providers/providers.dart';

import 'student_test_helpers.dart';

void main() {
  late MockParticipationRepository mockParticipationRepository;
  late StreamController<List<Participation>> participationsController;

  setUp(() {
    mockParticipationRepository = MockParticipationRepository();
    participationsController = StreamController<List<Participation>>.broadcast();

    mockParticipationRepository.participationsStream = participationsController.stream;
  });

  tearDown(() {
    participationsController.close();
  });

  testWidgets('StudentDetailPage displays student info and stats', (tester) async {
    final student = Student(
      id: 1,
      firstName: 'Max',
      lastName: 'Mustermann',
      shortCode: 'MM',
      classId: 1,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          participationRepositoryProvider.overrideWithValue(mockParticipationRepository),
        ],
        child: MaterialApp(
          home: StudentDetailPage(
            student: student,
            subjectId: 1,
          ),
        ),
      ),
    );

    // Verify student info
    expect(find.text('Max Mustermann'), findsOneWidget);
    expect(find.text('MM'), findsOneWidget);

    // Emit participations
    final participations = [
      Participation(
        id: 1,
        studentId: 1,
        subjectId: 1,
        date: DateTime.now(),
        isPositive: true,
      ),
      Participation(
        id: 2,
        studentId: 1,
        subjectId: 1,
        date: DateTime.now(),
        isPositive: false,
        note: 'Stört',
      ),
    ];
    participationsController.add(participations);
    await tester.pumpAndSettle();

    // Verify stats
    expect(find.text('Positiv'), findsOneWidget);
    expect(find.text('1'), findsNWidgets(2)); // One for positive count, one for negative count (wait, no)
    // Positive count is 1. Negative count is 1.
    // Let's be more specific.
    // The StatCard displays the label and the count.
    // We can find the StatCard by label and check its child.
    
    // Verify list items
    expect(find.text('Mitarbeit'), findsOneWidget);
    expect(find.text('Stört'), findsOneWidget);
  });

  testWidgets('StudentDetailPage allows deleting participation', (tester) async {
    final student = Student(
      id: 1,
      firstName: 'Max',
      lastName: 'Mustermann',
      shortCode: 'MM',
      classId: 1,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          participationRepositoryProvider.overrideWithValue(mockParticipationRepository),
        ],
        child: MaterialApp(
          home: StudentDetailPage(
            student: student,
            subjectId: 1,
          ),
        ),
      ),
    );

    final participations = [
      Participation(
        id: 1,
        studentId: 1,
        subjectId: 1,
        date: DateTime.now(),
        isPositive: true,
      ),
    ];
    participationsController.add(participations);
    await tester.pumpAndSettle();

    // Tap delete button
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(mockParticipationRepository.deletedParticipationIds, contains(1));
  });
}
