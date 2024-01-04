import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var overlayController = OverlayPortalController();

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            overlayController.toggle();
          },
          child: OverlayPortal(
            controller: overlayController,
            overlayChildBuilder: (BuildContext context) {
              return const Positioned(
                top: 100,
                child: Text(
                  'Overlay',
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
            child: const Text('Click Me'),
          ),
        ),
      ),
    );
  }
}
