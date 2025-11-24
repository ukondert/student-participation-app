import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/presentation/organisms/dialogs/confirm_dialog.dart';

void main() {
  group('ConfirmDialog', () {
    testWidgets('renders title and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ConfirmDialog(
              title: 'Test Title',
              message: 'Test Message',
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Message'), findsOneWidget);
    });

    testWidgets('shows default button labels', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ConfirmDialog(
              title: 'Test',
              message: 'Message',
            ),
          ),
        ),
      );

      expect(find.text('Bestätigen'), findsOneWidget);
      expect(find.text('Abbrechen'), findsOneWidget);
    });

    testWidgets('shows custom button labels', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ConfirmDialog(
              title: 'Test',
              message: 'Message',
              confirmLabel: 'Yes',
              cancelLabel: 'No',
            ),
          ),
        ),
      );

      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('calls onConfirm when confirm button is tapped',
        (tester) async {
      var confirmCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConfirmDialog(
              title: 'Test',
              message: 'Message',
              onConfirm: () => confirmCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Bestätigen'));
      expect(confirmCalled, isTrue);
    });

    testWidgets('calls onCancel when cancel button is tapped',
        (tester) async {
      var cancelCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConfirmDialog(
              title: 'Test',
              message: 'Message',
              onCancel: () => cancelCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abbrechen'));
      expect(cancelCalled, isTrue);
    });

    testWidgets('static show method displays dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ConfirmDialog.show(
                    context: context,
                    title: 'Delete',
                    message: 'Are you sure?',
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Are you sure?'), findsOneWidget);
    });

    testWidgets('dialog returns true when confirmed', (tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await ConfirmDialog.show(
                    context: context,
                    title: 'Test',
                    message: 'Message',
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Bestätigen'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('dialog returns false when cancelled', (tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await ConfirmDialog.show(
                    context: context,
                    title: 'Test',
                    message: 'Message',
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Abbrechen'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });
  });
}
