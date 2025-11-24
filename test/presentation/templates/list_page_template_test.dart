import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/presentation/templates/list_page_template.dart';
import 'package:student_participation_app/presentation/organisms/navigation/custom_bottom_nav.dart';

void main() {
  group('ListPageTemplate', () {
    testWidgets('renders title and list', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ListPageTemplate(
            title: 'Test List',
            list: Text('List Content'),
          ),
        ),
      );

      expect(find.text('Test List'), findsOneWidget);
      expect(find.text('List Content'), findsOneWidget);
    });

    testWidgets('shows FAB when onAdd is provided', (tester) async {
      var addCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ListPageTemplate(
            title: 'Test',
            list: const Text('List'),
            onAdd: () => addCalled = true,
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      
      await tester.tap(find.byType(FloatingActionButton));
      expect(addCalled, isTrue);
    });

    testWidgets('hides FAB when onAdd is not provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ListPageTemplate(
            title: 'Test',
            list: Text('List'),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('uses custom add button label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ListPageTemplate(
            title: 'Test',
            list: const Text('List'),
            onAdd: () {},
            addButtonLabel: 'Custom Add',
          ),
        ),
      );

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.tooltip, equals('Custom Add'));
    });

    testWidgets('uses custom add button icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ListPageTemplate(
            title: 'Test',
            list: const Text('List'),
            onAdd: () {},
            addButtonIcon: Icons.create,
          ),
        ),
      );

      expect(find.byIcon(Icons.create), findsOneWidget);
    });

    testWidgets('shows actions when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ListPageTemplate(
            title: 'Test',
            list: const Text('List'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('shows bottom navigation when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ListPageTemplate(
            title: 'Test',
            list: const Text('List'),
            showBottomNavigation: true,
            bottomNavItems: [
              NavItem(icon: Icons.home, label: 'Home'),
              NavItem(icon: Icons.list, label: 'List'),
            ],
            currentNavIndex: 1,
            onNavTap: (_) {},
          ),
        ),
      );

      expect(find.byType(CustomBottomNav), findsOneWidget);
    });
  });
}
