import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DefaultLayout extends StatelessWidget {
  final Widget body;

  const DefaultLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(GoRouterState.of(context).location),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: body,
        ));
  }
}
