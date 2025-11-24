import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/presentation/templates/base_page_template.dart';
import 'package:student_participation_app/presentation/organisms/navigation/custom_bottom_nav.dart';

void main() {
  group('BasePageTemplate', () {
    testWidgets('renders title and body', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BasePageTemplate(
            title: 'Test Title',
            body: Text('Test Body'),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Body'), findsOneWidget);
    });

    testWidgets('shows actions when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BasePageTemplate(
            title: 'Test',
            body: const Text('Body'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('shows FAB when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BasePageTemplate(
            title: 'Test',
            body: const Text('Body'),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('hides bottom navigation by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BasePageTemplate(
            title: 'Test',
            body: Text('Body'),
          ),
        ),
      );

      expect(find.byType(CustomBottomNav), findsNothing);
    });

    testWidgets('shows bottom navigation when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BasePageTemplate(
            title: 'Test',
            body: const Text('Body'),
            showBottomNavigation: true,
            bottomNavItems: [
              NavItem(icon: Icons.home, label: 'Home'),
              NavItem(icon: Icons.settings, label: 'Settings'),
            ],
            currentNavIndex: 0,
            onNavTap: (_) {},
          ),
        ),
      );

      expect(find.byType(CustomBottomNav), findsOneWidget);
    });

    testWidgets('shows leading widget when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BasePageTemplate(
            title: 'Test',
            body: const Text('Body'),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });
  });
}
