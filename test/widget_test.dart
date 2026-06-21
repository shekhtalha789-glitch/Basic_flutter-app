// Week 1 widget tests for the login screen: form validation + navigation.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:intern_tasks/main.dart';

void main() {
  testWidgets('shows validation errors for empty email and password',
      (WidgetTester tester) async {
    await tester.pumpWidget(const InternTasksApp());

    // Tap Login without entering anything.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Password cannot be empty'), findsOneWidget);
  });

  testWidgets('rejects a malformed email', (WidgetTester tester) async {
    await tester.pumpWidget(const InternTasksApp());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'not-an-email');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'secret');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
  });

  testWidgets('navigates to home on valid credentials',
      (WidgetTester tester) async {
    await tester.pumpWidget(const InternTasksApp());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'user@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'secret');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Login successful'), findsOneWidget);
    expect(find.text('Signed in as user@example.com'), findsOneWidget);
  });
}
