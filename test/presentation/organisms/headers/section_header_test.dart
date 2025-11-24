import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/presentation/organisms/headers/section_header.dart';

void main() {
  group('SectionHeader', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Test Section',
            ),
          ),
        ),
      );

      expect(find.text('Test Section'), findsOneWidget);
    });

    testWidgets('hides action when not provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Test Section',
            ),
          ),
        ),
      );

      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('shows action label when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Test Section',
              actionLabel: 'Add',
              onActionTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('shows action icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Test Section',
              actionLabel: 'Add',
              actionIcon: Icons.add,
              onActionTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('calls onActionTap when action is tapped', (tester) async {
      var actionCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Test Section',
              actionLabel: 'Add',
              onActionTap: () => actionCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add'));
      expect(actionCalled, isTrue);
    });

    testWidgets('does not show action if only label provided without callback',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Test Section',
              actionLabel: 'Add',
            ),
          ),
        ),
      );

      expect(find.text('Add'), findsNothing);
    });

    testWidgets('does not show action if only callback provided without label',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Test Section',
              onActionTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(InkWell), findsNothing);
    });
  });
}
