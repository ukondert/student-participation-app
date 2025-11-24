import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/presentation/atoms/indicators/avatar.dart';

void main() {
  group('Avatar', () {
    testWidgets('renders with initials when no image provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Avatar(
              name: 'John Doe',
            ),
          ),
        ),
      );

      expect(find.text('JD'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('renders single initial for single name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Avatar(
              name: 'John',
            ),
          ),
        ),
      );

      expect(find.text('J'), findsOneWidget);
    });

    testWidgets('renders with custom size', (tester) async {
      const customSize = 64.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Avatar(
              name: 'John Doe',
              size: customSize,
            ),
          ),
        ),
      );

      final avatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar),
      );
      expect(avatar.radius, equals(customSize / 2));
    });

    testWidgets('handles empty name gracefully', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Avatar(
              name: '',
            ),
          ),
        ),
      );

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('uses custom background color when provided', (tester) async {
      const customColor = Colors.red;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Avatar(
              name: 'John Doe',
              backgroundColor: customColor,
            ),
          ),
        ),
      );

      final avatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar),
      );
      expect(avatar.backgroundColor, equals(customColor));
    });
  });
}
