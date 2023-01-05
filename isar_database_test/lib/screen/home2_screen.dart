import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home2Screen extends StatelessWidget {
  const Home2Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box>(
        valueListenable: Hive.box('testBox').listenable(),
        builder: (context, box, widget) {
          return Column(
            children: box.values
                .map(
                  (e) => Text(e.toString()),
            )
                .toList(),
          );
        },
      ),
    );
  }
}
