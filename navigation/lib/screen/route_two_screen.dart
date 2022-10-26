import 'package:flutter/material.dart';
import 'package:navigation/layout/main_layout.dart';
import 'package:navigation/screen/route_three_screen.dart';

class RouteTwoScreen extends StatelessWidget {
  const RouteTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;

    return MainLayout(
      title: 'Route Two',
      children: [
        Text(
          'arguments: ${arguments}',
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Pop'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              '/three',
              arguments: 999,
            );
          },
          child: Text('Push Named'),
        ),
        ElevatedButton(
          onPressed: () {
            // [HomeScreen(), RouteOne(), RouteTwo(), RouteThree()] - 보통
            // [HomeScreen(), RouteOne(), RouteThree()] - Replacement: 두번째페이지 사라짐
            Navigator.of(context).pushReplacementNamed(
              '/three',
            );
          },
          child: Text('Push Replacement'),
        ),
        ElevatedButton(
          onPressed: () {
            // [HomeScreen()]
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => RouteThreeScreen(),
              ),
              // (route) => route.settings.name == '/',
              (route) => false, // 모든 route 삭제, true는 다 살린다
            );
          },
          child: Text('Push And Remove Until'),
        ),
        ElevatedButton(
          onPressed: () {
            // [HomeScreen(), RouteOne(), RouteTwo(), RouteThree()]
            // [HomeScreen()]
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/three',
              (route) => route.settings.name == '/',
              // RouteThree, RouteTwo, RouteOne 이름이 / 가 아니므로 HomeScreen만 남기고 다 삭제한다
            );
          },
          child: Text('Push Named And Remove Until'),
        ),
      ],
    );
  }
}
