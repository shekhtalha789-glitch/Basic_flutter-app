// Week 3 widget tests for the task manager: add, mark complete, delete and
// persistence via SharedPreferences (mocked).

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intern_tasks/screens/task_manager_screen.dart';

Future<void> pumpTaskManager(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: TaskManagerScreen()));
  await tester.pumpAndSettle();
}

/// Drives the add-task dialog to completion with [title].
Future<void> addTask(WidgetTester tester, String title) async {
  // Use the AppBar action (FAB and action share the same flow).
  await tester.tap(find.byTooltip('Add task').first);
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), title);
  await tester.tap(find.widgetWithText(FilledButton, 'Add'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows empty state initially', (tester) async {
    await pumpTaskManager(tester);
    expect(find.text('No tasks yet. Tap + to add one.'), findsOneWidget);
  });

  testWidgets('adds a task via the add dialog', (tester) async {
    await pumpTaskManager(tester);
    await addTask(tester, 'Ship the app');

    expect(find.text('Ship the app'), findsOneWidget);
    expect(find.text('1 of 1 remaining'), findsOneWidget);
  });

  testWidgets('marks a task complete', (tester) async {
    await pumpTaskManager(tester);
    await addTask(tester, 'Write tests');

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    expect(find.text('0 of 1 remaining'), findsOneWidget);
  });

  testWidgets('deletes a task via the trailing button', (tester) async {
    await pumpTaskManager(tester);
    await addTask(tester, 'Throwaway');
    expect(find.text('Throwaway'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Throwaway'), findsNothing);
    expect(find.text('No tasks yet. Tap + to add one.'), findsOneWidget);
  });

  testWidgets('loads previously saved tasks with their done state',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'task_manager_tasks': jsonEncode([
        {'title': 'Done task', 'done': true},
        {'title': 'Open task', 'done': false},
      ]),
    });
    await pumpTaskManager(tester);

    expect(find.text('Done task'), findsOneWidget);
    expect(find.text('Open task'), findsOneWidget);
    expect(find.text('1 of 2 remaining'), findsOneWidget);
  });

  testWidgets('persists added tasks across rebuilds', (tester) async {
    await pumpTaskManager(tester);
    await addTask(tester, 'Persisted');

    await pumpTaskManager(tester);
    expect(find.text('Persisted'), findsOneWidget);
  });
}
