import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // await authProvider.logout(context);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Chào mừng đến Dashboard!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}