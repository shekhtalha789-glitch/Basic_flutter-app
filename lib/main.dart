import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const InternTasksApp());
}

/// Root of the app.
///
/// Week 1 deliverable: the app opens on the login screen and, after a valid
/// login, navigates to the home screen. Later weeks add Counter, To-Do and
/// Task Manager features reachable from the home screen.
class InternTasksApp extends StatelessWidget {
  const InternTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intern Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
