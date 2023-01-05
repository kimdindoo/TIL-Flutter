import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar_database_test/screen/home2_screen.dart';
import 'package:isar_database_test/screen/isar_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('testBox');

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              print('keys : ${box.keys.toList()}');
              print('values: ${box.values.toList()}');
            },
            child: Text('박스 프린트하기!'),
          ),
          ElevatedButton(
            onPressed: () {
              // for(int i = 0; i < 100; i++) {
              //   box.put(i, i);
              // }
              box.put(100, '백');
            },
            child: Text('데이터 넣기!'),
          ),
          ElevatedButton(
            onPressed: () {
              box.deleteAt(0);
            },
            child: Text('데이터 삭제!'),
          ),
          ElevatedButton(
            onPressed: () {
              print(box.get(10));
            },
            child: Text('데이터 가져오기!'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Home2Screen(),
                ),
              );
            },
            child: Text('다음페이지!'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => IsarScreen(),
                ),
              );
            },
            child: Text('Isar Test 페이지!'),
          ),
        ],
      ),
    );
  }
}
