import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:help_study/main.dart';

void main() {
  testWidgets('Test start, stop, and restart timer',
      (WidgetTester tester) async {

    await tester.pumpWidget(const MyApp());

    final playPauseButtonFinder = find.byKey(const Key('playPauseButton'));

    await tester.tap(playPauseButtonFinder);
    await tester.pumpAndSettle();

    // Verify that the timer is running
    expect(find.text('00:00:01'), findsOneWidget);

    await tester.tap(playPauseButtonFinder);
    await tester.pumpAndSettle();

    // Verify that the timer is stopped
    expect(find.text('00:00:01'), findsOneWidget);

    await tester.tap(find.byKey(const Key('restartButton')));
    await tester.pumpAndSettle();

    // Verify that the timer is reset
    expect(find.text('00:00:00'), findsOneWidget);
  });

  testWidgets('Test save time, clear table and total', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final playPauseButtonFinder = find.byKey(const Key('playPauseButton'));

    await tester.tap(playPauseButtonFinder);
    await tester.pumpAndSettle();

    await tester.tap(playPauseButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    final saveButtonFinder = find.byKey(const Key('saveButton'));
    await tester.tap(saveButtonFinder);
    await tester.pumpAndSettle();

    // Verify we have main and saved timer the same value
    expect(find.text('00:00:01'), findsNWidgets(2));
    // Verify the total timer
    expect(find.text('Total: 00:00:01'), findsOneWidget);

    final clearButton = find.byKey(const Key('restartButton'));
    await tester.tap(clearButton);
    await tester.pumpAndSettle();

    // Verify main timer is cleared
    expect(find.text('00:00:00'), findsOneWidget);
    // Verify saved timer is unchanched
    expect(find.text('00:00:01'), findsOneWidget);
  });
}
