import 'package:flutter/material.dart';

class NestedChildScreen extends StatelessWidget {
  final String routeName;
  const NestedChildScreen({super.key, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(routeName),
    );
  }
}
