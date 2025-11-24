import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/presentation/providers/providers.dart';
import 'package:student_participation_app/presentation/pages/subjects/all_subjects_page.dart';
import 'package:student_participation_app/presentation/pages/subjects/export_subjects_page.dart';
import 'package:student_participation_app/presentation/pages/subjects/protocol_subjects_page.dart';
import 'package:student_participation_app/presentation/widgets/subject_list_widget.dart';

import '../pages/classes/class_test_helpers.dart';

void main() {
  late MockClassRepository mockClassRepository;

  setUp(() {
    mockClassRepository = MockClassRepository();
  });

  Widget createWidgetUnderTest(Widget child) {
    return ProviderScope(
      overrides: [
        classRepositoryProvider.overrideWithValue(mockClassRepository),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  final testSubjects = [
    Subject(id: 1, name: 'Math', shortName: 'MAT', classId: 1),
    Subject(id: 2, name: 'English', shortName: 'ENG', classId: 1),
  ];

  final testClasses = [
    SchoolClass(id: 1, name: 'Class 1A'),
  ];

  group('Subject List Screens', () {
    testWidgets('AllSubjectsPage renders SubjectListWidget', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const AllSubjectsPage()));

      expect(find.byType(SubjectListWidget), findsOneWidget);
      expect(find.text('Alle Fächer'), findsOneWidget);
    });

    testWidgets('ProtocolSubjectsPage renders SubjectListWidget', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const ProtocolSubjectsPage()));

      expect(find.byType(SubjectListWidget), findsOneWidget);
      expect(find.text('Protokoll'), findsOneWidget);
    });

    testWidgets('ExportSubjectsPage renders SubjectListWidget', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const ExportSubjectsPage()));

      expect(find.byType(SubjectListWidget), findsOneWidget);
      expect(find.text('Export'), findsOneWidget);
    });

    testWidgets('AllSubjectsPage displays subjects', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const AllSubjectsPage()));

      mockClassRepository.emitSubjects(testSubjects);
      await tester.pump(); // Rebuild to show inner StreamBuilder

      mockClassRepository.emitClasses(testClasses);
      await tester.pumpAndSettle();

      expect(find.text('Math'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Class 1A'), findsNWidgets(2));
    });
  });
}
