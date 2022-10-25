import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timer;
  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 4), (timer) {
      // print("Timer!");
      int currentPage = controller.page!.toInt();
      int nextPage = currentPage + 1;

      if (nextPage > 4) {
        nextPage = 0;
      }

      controller.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    if (timer != null) {
      timer!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: PageView(
        controller: controller,
        children: [
          // Image.asset(
          //   'asset/img/image_1.jpeg',
          //   fit: BoxFit.cover,
          // ),
          // Image.asset(
          //   'asset/img/image_2.jpeg',
          //   fit: BoxFit.cover,
          // ),
          // Image.asset(
          //   'asset/img/image_3.jpeg',
          //   fit: BoxFit.cover,
          // ),
          // Image.asset(
          //   'asset/img/image_4.jpeg',
          //   fit: BoxFit.cover,
          // ),
          // Image.asset(
          //   'asset/img/image_5.jpeg',
          //   fit: BoxFit.cover,
          // ),
          1, 2, 3, 4, 5
        ]
            .map(
              (e) => Image.asset(
                'asset/img/image_$e.jpeg',
                fit: BoxFit.cover,
              ),
            )
            .toList(),
      ),
    );
  }
}
