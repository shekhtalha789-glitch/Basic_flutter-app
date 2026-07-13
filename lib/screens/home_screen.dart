import 'package:flutter/material.dart';

import 'counter_screen.dart';
import 'task_manager_screen.dart';
import 'todo_screen.dart';
import 'posts_list_screen.dart';
import 'user_profile_screen.dart';
import 'users_list_screen.dart';

/// The app "hub", reached from the login screen.
///
/// Week 1 confirmed navigation works. From Week 2 on, this screen is the launch
/// pad for each feature built during the internship: Counter, To-Do and (later)
/// the Task Manager.
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Signed in as $email',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _FeatureCard(
            icon: Icons.exposure,
            title: 'Counter',
            subtitle: 'Week 2 — setState + persistent storage',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CounterScreen()),
            ),
          ),
          _FeatureCard(
            icon: Icons.checklist,
            title: 'To-Do List',
            subtitle: 'Week 2 — add tasks, ListView, persistent storage',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TodoScreen()),
            ),
          ),
          _FeatureCard(
            icon: Icons.task_alt,
            title: 'Task Manager',
            subtitle: 'Week 3 — add, complete, delete; persistent storage',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TaskManagerScreen()),
            ),
          ),
          _FeatureCard(
            icon: Icons.list_alt,
            title: 'Posts (Week 4)',
            subtitle: 'API Integration, ListView.builder, state handling',
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const PostsListScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
          ),
          _FeatureCard(
            icon: Icons.people,
            title: 'Users List',
            subtitle: 'API Integration, List of Users',
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const UsersListScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A tappable card linking to one feature screen on the hub.
class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
