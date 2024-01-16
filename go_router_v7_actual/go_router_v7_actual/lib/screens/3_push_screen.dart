import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_v7_actual/layout/default_layout.dart';

class PushScreen extends StatelessWidget {
  const PushScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              context.push('/basic');
            },
            child: const Text('Push Basic'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/basic');
            },
            child: const Text('Go Basic'),
          ),
        ],
      ),
    );
  }
}
