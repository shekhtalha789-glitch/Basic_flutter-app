// Week 2 widget tests for the counter screen: increment/decrement, reset and
// persistence via SharedPreferences (mocked).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intern_tasks/screens/counter_screen.dart';

Future<void> pumpCounter(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: CounterScreen()));
  // initState loads the saved value asynchronously.
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    // Start every test from an empty store.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('starts at 0 when nothing is stored', (tester) async {
    await pumpCounter(tester);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('increments and decrements', (tester) async {
    await pumpCounter(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Increase'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Decrease'));
    await tester.tap(find.widgetWithText(FilledButton, 'Decrease'));
    await tester.pump();
    expect(find.text('-1'), findsOneWidget);
  });

  testWidgets('reset returns to 0', (tester) async {
    await pumpCounter(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Increase'));
    await tester.pump();
    await tester.tap(find.byTooltip('Reset'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('loads a previously saved value', (tester) async {
    SharedPreferences.setMockInitialValues({'counter_value': 7});
    await pumpCounter(tester);
    expect(find.text('7'), findsOneWidget);
  });

  testWidgets('persists the value across rebuilds', (tester) async {
    await pumpCounter(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Increase'));
    await tester.tap(find.widgetWithText(FilledButton, 'Increase'));
    await tester.pumpAndSettle();

    // Re-mount a fresh CounterScreen; it should read back the saved value.
    await pumpCounter(tester);
    expect(find.text('2'), findsOneWidget);
  });
}
