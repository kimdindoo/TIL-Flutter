import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login app',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: LogIn(),
    );
  }
}

class LogIn extends StatelessWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Sign In',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0.2,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonTheme(
              height: 50.0,
              child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // 중앙정렬 하기 위해
                  // 버튼 Text 양쪽에 로고를 넣고, 하나는 투명도를 0으로 해 안보이게
                  children: [
                    Image.asset('images/glogo.png'),
                    Text(
                      'Login with Google',
                      style: TextStyle(color: Colors.black87, fontSize: 15.0),
                    ),
                    Opacity(
                      opacity: 0.0,
                      child: Image.asset('images/glogo.png'),
                    )
                  ],
                ),
                color: Colors.white,
                onPressed: () {},
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              )),
            ),
            SizedBox(
              height: 10,
            ),
            ButtonTheme(
              height: 50.0,
              child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // 중앙정렬 하기 위해
                  // 버튼 Text 양쪽에 로고를 넣고, 하나는 투명도를 0으로 해 안보이게
                  children: [
                    Image.asset('images/flogo.png'),
                    Text(
                      'Login with Facebook',
                      style: TextStyle(color: Colors.black87, fontSize: 15.0),
                    ),
                    Opacity(
                      opacity: 0.0,
                      child: Image.asset('images/flogo.png'),
                    )
                  ],
                ),
                color: Color(0xFF334D92),
                onPressed: () {},
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              )),
            ),
            SizedBox(
              height: 10,
            ),
            ButtonTheme(
              height: 50.0,
              child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // 중앙정렬 하기 위해
                  // 버튼 Text 양쪽에 로고를 넣고, 하나는 투명도를 0으로 해 안보이게
                  children: [
                    Icon(
                      Icons.mail,
                      color: Colors.white,
                    ),
                    Text(
                      'Login with Email',
                      style: TextStyle(color: Colors.black87, fontSize: 15.0),
                    ),
                    Opacity(
                      opacity: 0.0,
                      child: Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                color: Colors.green,
                onPressed: () {},
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
