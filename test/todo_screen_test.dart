// Week 2 widget tests for the to-do screen: add, display in a ListView, delete
// and persistence via SharedPreferences (mocked).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intern_tasks/screens/todo_screen.dart';

Future<void> pumpTodo(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: TodoScreen()));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows empty state when there are no tasks', (tester) async {
    await pumpTodo(tester);
    expect(find.text('No tasks yet. Add one above.'), findsOneWidget);
  });

  testWidgets('adds a task and clears the field', (tester) async {
    await pumpTodo(tester);

    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pump();

    expect(find.text('Buy milk'), findsOneWidget);
    // The input field is cleared after adding.
    expect(find.widgetWithText(TextField, 'Buy milk'), findsNothing);
  });

  testWidgets('ignores blank input', (tester) async {
    await pumpTodo(tester);

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pump();

    expect(find.text('No tasks yet. Add one above.'), findsOneWidget);
  });

  testWidgets('deletes a task via the trailing button', (tester) async {
    await pumpTodo(tester);

    await tester.enterText(find.byType(TextField), 'Walk the dog');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pump();
    expect(find.text('Walk the dog'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pump();
    expect(find.text('Walk the dog'), findsNothing);
  });

  testWidgets('loads previously saved tasks', (tester) async {
    SharedPreferences.setMockInitialValues({
      'todo_items': ['Task A', 'Task B'],
    });
    await pumpTodo(tester);

    expect(find.text('Task A'), findsOneWidget);
    expect(find.text('Task B'), findsOneWidget);
  });

  testWidgets('persists added tasks across rebuilds', (tester) async {
    await pumpTodo(tester);
    await tester.enterText(find.byType(TextField), 'Persisted task');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();

    await pumpTodo(tester);
    expect(find.text('Persisted task'), findsOneWidget);
  });
}
