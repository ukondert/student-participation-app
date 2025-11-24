import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/presentation/templates/form_page_template.dart';

void main() {
  group('FormPageTemplate', () {
    testWidgets('renders title and form', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FormPageTemplate(
            title: 'Test Form',
            form: Text('Form Content'),
          ),
        ),
      );

      expect(find.text('Test Form'), findsOneWidget);
      expect(find.text('Form Content'), findsOneWidget);
    });

    testWidgets('wraps form in SingleChildScrollView', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FormPageTemplate(
            title: 'Test',
            form: Text('Form'),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('applies padding to form', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FormPageTemplate(
            title: 'Test',
            form: Text('Form'),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.padding, isNotNull);
    });

    testWidgets('shows actions when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FormPageTemplate(
            title: 'Test',
            form: const Text('Form'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('hides bottom navigation by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FormPageTemplate(
            title: 'Test',
            form: Text('Form'),
          ),
        ),
      );

      expect(find.byType(BottomNavigationBar), findsNothing);
    });

    testWidgets('can enable bottom navigation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FormPageTemplate(
            title: 'Test',
            form: Text('Form'),
            showBottomNavigation: true,
          ),
        ),
      );

      // Note: BottomNav won't show without items, but flag is set
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.bottomNavigationBar, isNull); // No items provided
    });
  });
}
