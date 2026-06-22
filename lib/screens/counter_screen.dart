import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Week 2 — State Management Basics + Persistent Data Storage.
///
/// A simple counter whose value is managed with [setState] (no third-party
/// state library, on purpose) and persisted with [SharedPreferences] so it
/// survives an app restart.
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  /// SharedPreferences key under which the counter value is stored.
  static const _prefsKey = 'counter_value';

  int _count = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  /// Reads the saved counter value on startup. Defaults to 0 when nothing has
  /// been stored yet.
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _count = prefs.getInt(_prefsKey) ?? 0;
      _loading = false;
    });
  }

  /// Persists the current value. Fire-and-forget: the UI already reflects the
  /// new value via [setState], so we don't block on the write.
  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, _count);
  }

  void _increment() {
    setState(() => _count++);
    _saveCounter();
  }

  void _decrement() {
    setState(() => _count--);
    _saveCounter();
  }

  void _reset() {
    setState(() => _count = 0);
    _saveCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        actions: [
          IconButton(
            tooltip: 'Reset',
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _reset,
          ),
        ],
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Current value',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_count',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Saved automatically — restart the app to confirm.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: _decrement,
                        icon: const Icon(Icons.remove),
                        label: const Text('Decrease'),
                      ),
                      const SizedBox(width: 16),
                      FilledButton.icon(
                        onPressed: _increment,
                        icon: const Icon(Icons.add),
                        label: const Text('Increase'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
