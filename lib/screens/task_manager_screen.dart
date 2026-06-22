import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A single task: its text and whether it has been completed.
class Task {
  Task({required this.title, this.done = false});

  final String title;
  bool done;

  Map<String, dynamic> toJson() => {'title': title, 'done': done};

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'] as String,
        done: json['done'] as bool? ?? false,
      );
}

/// Week 3 — Final Project: Task Management App.
///
/// A home screen that lists tasks and lets the user add, delete and mark them
/// complete. Tasks are persisted with [SharedPreferences] (encoded as JSON).
/// Uses a custom [AppBar] with a title and an add action, plus a floating
/// action button — both wired to the same "add task" flow.
class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  /// SharedPreferences key under which the task list is stored (JSON string).
  static const _prefsKey = 'task_manager_tasks';

  List<Task> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  /// Reads and decodes the saved tasks on startup. Defaults to an empty list.
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (!mounted) return;
    setState(() {
      _tasks = raw == null
          ? []
          : (jsonDecode(raw) as List)
              .map((e) => Task.fromJson(e as Map<String, dynamic>))
              .toList();
      _loading = false;
    });
  }

  /// Encodes and persists the current task list.
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_prefsKey, raw);
  }

  void _addTask(String title) {
    final text = title.trim();
    if (text.isEmpty) return;
    setState(() => _tasks.add(Task(title: text)));
    _saveTasks();
  }

  void _toggleTask(int index) {
    setState(() => _tasks[index].done = !_tasks[index].done);
    _saveTasks();
  }

  void _deleteTask(int index) {
    final removed = _tasks[index];
    setState(() => _tasks.removeAt(index));
    _saveTasks();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Deleted "${removed.title}"')));
  }

  /// Shows a dialog to enter a new task. Triggered by both the AppBar action
  /// and the floating action button.
  Future<void> _showAddTaskDialog() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) => Navigator.pop(context, value),
          decoration: const InputDecoration(
            hintText: 'What needs doing?',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (title != null) _addTask(title);
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _tasks.where((t) => !t.done).length;
    return Scaffold(
      // Custom AppBar: title + an add action button.
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            tooltip: 'Add task',
            icon: const Icon(Icons.add),
            onPressed: _loading ? null : _showAddTaskDialog,
          ),
        ],
      ),
      floatingActionButton: _loading
          ? null
          : FloatingActionButton(
              tooltip: 'Add task',
              onPressed: _showAddTaskDialog,
              child: const Icon(Icons.add),
            ),
      body: _buildBody(remaining),
    );
  }

  Widget _buildBody(int remaining) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_tasks.isEmpty) {
      return const Center(
        child: Text('No tasks yet. Tap + to add one.'),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '$remaining of ${_tasks.length} remaining',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              final task = _tasks[index];
              return Dismissible(
                key: ValueKey('$index-${task.title}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => _deleteTask(index),
                child: CheckboxListTile(
                  value: task.done,
                  onChanged: (_) => _toggleTask(index),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    task.title,
                    style: task.done
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  secondary: IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _deleteTask(index),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
