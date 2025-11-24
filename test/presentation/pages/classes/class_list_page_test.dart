import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/domain/entities/entities.dart';

import 'package:student_participation_app/presentation/molecules/states/state_components.dart';
import 'package:student_participation_app/presentation/pages/classes/class_list_page.dart';
import 'package:student_participation_app/presentation/providers/providers.dart';

import 'class_test_helpers.dart';

void main() {
  late MockClassRepository mockRepository;

  setUp(() {
    mockRepository = MockClassRepository();
  });


  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          classRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          home: ClassListPage(),
        ),
      ),
    );
  }

  testWidgets('ClassListPage shows loading state initially', (tester) async {
    await pumpPage(tester);
    // Initial state of StreamBuilder with no data is waiting
    expect(find.byType(LoadingState), findsOneWidget);
    expect(find.text('Lade Klassen...'), findsOneWidget);
  });

  testWidgets('ClassListPage shows empty state when no classes', (tester) async {
    await pumpPage(tester);
    mockRepository.emitClasses([]);
    await tester.pump();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('Keine Klassen vorhanden'), findsOneWidget);
    expect(find.text('Tippe auf +, um eine Klasse hinzuzufügen'), findsOneWidget);
  });

  testWidgets('ClassListPage shows error state when stream errors', (tester) async {
    await pumpPage(tester);
    mockRepository.emitError('Database error');
    await tester.pump();

    expect(find.byType(ErrorState), findsOneWidget);
    expect(find.text('Fehler beim Laden der Klassen'), findsOneWidget);
  });

  testWidgets('ClassListPage shows list of classes', (tester) async {
    await pumpPage(tester);
    final classes = [
      SchoolClass(id: 1, name: '1A', teacher: 'Mr. Smith', room: '101', schoolYear: '2023'),
      SchoolClass(id: 2, name: '2B', teacher: 'Mrs. Jones', room: '102', schoolYear: '2023'),
    ];
    mockRepository.emitClasses(classes);
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('1A'), findsOneWidget);
    expect(find.text('Mr. Smith • 101 • 2023'), findsOneWidget);
    expect(find.text('2B'), findsOneWidget);
    expect(find.text('Mrs. Jones • 102 • 2023'), findsOneWidget);
  });

  testWidgets('ClassListPage shows delete confirmation dialog', (tester) async {
    await pumpPage(tester);
    final classes = [
      SchoolClass(id: 1, name: '1A'),
    ];
    mockRepository.emitClasses(classes);
    await tester.pump();

    // Open menu
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    // Tap delete
    await tester.tap(find.text('Löschen'));
    await tester.pumpAndSettle();

    expect(find.text('1A löschen?'), findsOneWidget);
    expect(find.text('Löschen'), findsOneWidget);
    expect(find.text('Abbrechen'), findsOneWidget);
  });
}
