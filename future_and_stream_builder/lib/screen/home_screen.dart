import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 16.0,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<int>(
          stream: streamNumbers(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            // x
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
            // o
            // if(!snapshot.hasData){
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }

            // if(snapshot.hasData){
            //   // 데이터가 있을때 위젯 렌더링
            // }
            //
            // if(snapshot.hasError){
            //   // 에러가 났을때 위젯 렌더링
            // }

            // 로딩중일때

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'StreamBuilder',
                  style: textStyle.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 20.0),
                ),
                Text(
                  'ConState : ${snapshot.connectionState}',
                  style: textStyle,
                ),
                Text(
                  'Data : ${snapshot.data}',
                  style: textStyle,
                ),
                // 특정 영역만 Indicator 보이게
                // Row(
                //   children: [
                //     Text(
                //       'Data : ${snapshot.data}',
                //       style: textStyle,
                //     ),
                //     if(snapshot.connectionState == ConnectionState.waiting)
                //       CircularProgressIndicator(
                //
                //       ),
                //   ],
                // ),
                Text(
                  'Error : ${snapshot.error}',
                  style: textStyle,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text('setState'),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<int> getNumber() async {
    await Future.delayed(Duration(seconds: 3));

    final random = Random();

    // throw Exception('에러가 발생했습니다.');

    return random.nextInt(100);
  }

  Stream<int> streamNumbers() async* {
    for(int i = 0; i < 10; i ++){
      if(i == 5){
        throw Exception('i == 5');
      }
      await Future.delayed(Duration(seconds: 1));

      yield i;
    }
  }
}
