import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Week 2 — Simple List App.
///
/// A to-do list that lets the user add tasks, shows them in a [ListView], and
/// persists them with [SharedPreferences] (stored as a string list). Swipe a
/// row to delete it.
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  /// SharedPreferences key under which the task list is stored.
  static const _prefsKey = 'todo_items';

  final _controller = TextEditingController();
  List<String> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Reads the saved tasks on startup. Defaults to an empty list.
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _tasks = prefs.getStringList(_prefsKey) ?? [];
      _loading = false;
    });
  }

  /// Persists the current task list.
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _tasks);
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _tasks.add(text);
      _controller.clear();
    });
    _saveTasks();
  }

  void _removeTaskAt(int index) {
    final removed = _tasks[index];
    setState(() => _tasks.removeAt(index));
    _saveTasks();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Deleted "$removed"')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Column(
        children: [
          // Input row: text field + add button.
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addTask(),
                    decoration: const InputDecoration(
                      labelText: 'New task',
                      hintText: 'What needs doing?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_tasks.isEmpty) {
      return const Center(
        child: Text('No tasks yet. Add one above.'),
      );
    }
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Dismissible(
          // Index-based keys are fine here because deletion rebuilds the list.
          key: ValueKey('$index-$task'),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => _removeTaskAt(index),
          child: ListTile(
            leading: const Icon(Icons.check_box_outline_blank),
            title: Text(task),
            trailing: IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _removeTaskAt(index),
            ),
          ),
        );
      },
    );
  }
}
