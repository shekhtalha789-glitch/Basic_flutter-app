import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

import 'package:provider/provider.dart';
import 'providers/task_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const InternTasksApp(),
    ),
  );
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
      title: 'basic_app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
