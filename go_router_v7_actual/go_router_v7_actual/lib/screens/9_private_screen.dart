import 'package:flutter/material.dart';
import 'package:go_router_v7_actual/layout/default_layout.dart';

class PrivateScreen extends StatelessWidget {
  const PrivateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      body: Center(
        child: Text('Private Screen'),
      ),
    );
  }
}
