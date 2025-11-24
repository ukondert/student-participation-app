import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/presentation/molecules/cards/student_card.dart';

void main() {
  group('StudentCard', () {
    final testStudent = Student(
      id: 1,
      classId: 1,
      firstName: 'John',
      lastName: 'Doe',
      shortCode: 'JD',
    );

    testWidgets('renders student information', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StudentCard(student: testStudent),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Kürzel: JD'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StudentCard(
              student: testStudent,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('shows participation counters when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StudentCard(
              student: testStudent,
              showCounters: true,
              positiveCount: 5,
              negativeCount: 2,
            ),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle), findsOneWidget);
      expect(find.byIcon(Icons.remove_circle), findsOneWidget);
    });

    testWidgets('hides counters when showCounters is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StudentCard(
              student: testStudent,
              showCounters: false,
              positiveCount: 5,
              negativeCount: 2,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add_circle), findsNothing);
      expect(find.byIcon(Icons.remove_circle), findsNothing);
    });

    testWidgets('shows only positive counter when negative is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StudentCard(
              student: testStudent,
              showCounters: true,
              positiveCount: 5,
            ),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle), findsOneWidget);
      expect(find.byIcon(Icons.remove_circle), findsNothing);
    });

    testWidgets('renders avatar with student initials', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StudentCard(student: testStudent),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('shows chevron icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StudentCard(student: testStudent),
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });
  });
}
