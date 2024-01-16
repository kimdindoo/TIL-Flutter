import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_v7_actual/layout/default_layout.dart';

class PopBaseScreen extends StatelessWidget {
  const PopBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () async {
              final result = await context.push('/pop/return');
              print('result: $result');
            },
            child: const Text('Push Pop Return Screen'),
          ),
        ],
      ),
    );
  }
}
