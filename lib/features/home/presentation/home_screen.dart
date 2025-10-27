import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home Screen
class HomeScreen extends StatelessWidget {
  /// Constructor
  const HomeScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('loomday'), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.home, size: 96),
              const SizedBox(height: 16),
              const Text(
                'Home',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.go('/settings');
                },
                child: const Text('Go to Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
