import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('버튼'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('ButtonStyle'),
              style: ButtonStyle(
                // Material State
                //
                // hovered - 호버링 상태 (마우스 커서를 올려놓은상태)
                // focused - 포커스 됐을때 (텍스트 필드)
                // preesed - 눌렸을때 (o)
                // dragged - 드래그 됐을때
                // selected - 선택됐을때 (체크박스, 라디오 버튼)
                // scrollUnder - 다른 컴포넌트 밑으로 스크롤링 됐을때
                // disabled - 비활성화 됐을때 (o)
                // error - 에러상태

                // backgroundColor: MaterialStateProperty.all(
                //   Colors.black,
                // ),
                backgroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.green;
                    }
                    return Colors.black;
                  },
                ),
                foregroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.white;
                    }
                    return Colors.red;
                  },
                ),
                padding: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                    if(states.contains(MaterialState.pressed)){
                      return EdgeInsets.all(100.0);
                    }
                    return EdgeInsets.all(20.0);
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  // 메인 칼라
                  primary: Colors.red,
                  // 글자 및 애니메이션 색깔
                  onPrimary: Colors.black,
                  // 그림자 색깔
                  shadowColor: Colors.green,
                  // 3D 입체감의 높이
                  elevation: 10.0,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                  ),
                  padding: EdgeInsets.all(32.0),
                  side: BorderSide(
                    color: Colors.black,
                    width: 4.0,
                  )),
              child: Text('ElevatedButton'),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                primary: Colors.green,
                backgroundColor: Colors.yellow,
                elevation: 10.0,
              ),
              child: Text('OutlineButton'),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                primary: Colors.brown,
                backgroundColor: Colors.blue,
              ),
              child: Text('TextButton'),
            )
          ],
        ),
      ),
    );
  }
}
