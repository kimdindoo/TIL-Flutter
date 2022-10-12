import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toast message',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toast message'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            flutterToast();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("두번째 페이지 가기"),
                action: SnackBarAction(
                  label: '확인',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondPage()),
                    );
                  },
                ),
              ),
            );
          },
          child: Text('Toast'),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SecondPage'),
      ),
    );
  }
}


void flutterToast() {
  Fluttertoast.showToast(
      msg: 'Flutter',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.redAccent,
      fontSize: 20.0,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG);
}
