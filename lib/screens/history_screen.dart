import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/food_log.dart';
import '../services/firebase_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = true;
  String? _error;
  List<FoodLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
        _error = 'Please log in to see history.';
      });
      return;
    }

    try {
      final logs = await _firebaseService.fetchFoodLogs(user.uid);
      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load history.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _logs.isEmpty
                  ? const Center(child: Text('No scans yet.'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _logs.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        final time = TimeOfDay.fromDateTime(log.timestamp).format(context);
                        return ListTile(
                          leading: const Icon(Icons.restaurant),
                          title: Text(log.foodName),
                          subtitle: Text('${log.calories} kcal · $time'),
                        );
                      },
                    ),
    );
  }
}
