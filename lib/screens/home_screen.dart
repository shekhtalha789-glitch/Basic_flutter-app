import 'package:flutter/material.dart';

/// Week 1 — the second screen reached from the login screen.
///
/// This is the app "hub". In later weeks it gains buttons that navigate to the
/// Counter, To-Do and Task Manager features. For Week 1 it simply confirms that
/// navigation from the login screen works.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.email});

  /// The email entered on the login screen, passed through navigation.
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            // Pop back to the login screen.
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 72, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                'Login successful',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Signed in as $email',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              const Text(
                'Counter, To-Do and Task Manager features '
                'are added in the next weeks.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
