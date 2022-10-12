import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buttons',
      theme: ThemeData(primarySwatch: Colors.red),
      home: MyButtons(),
    );
  }
}

class MyButtons extends StatelessWidget {
  const MyButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buttons'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  print('text button');
                },
                onLongPress: () {
                  print('text button longPress');
                },
                child: Text(
                  'Text button',
                  style: TextStyle(fontSize: 20.0),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                  // backgroundColor: Colors.red
                )),
            ElevatedButton(
              onPressed: () {
                print('Elevated button');
              },
              child: Text('Elevated button'),
              style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 0.0,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                print('Outlined button');
              },
              child: Text('Outlined button'),
              style: OutlinedButton.styleFrom(
                primary: Colors.green,
                // side: BorderSide(
                //   color: Colors.black87,
                //   width: 2.0
                // )
              ),
            ),
            TextButton.icon(
              onPressed: () {
                print('Icon button');
              },
              icon: Icon(
                Icons.home,
                size: 30.0,
                // color: Colors.black87,
              ),
              label: Text('Go to home'),
              style: TextButton.styleFrom(
                primary: Colors.purple
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                print('Go to Home');
              },
              icon: Icon(
                Icons.home,
                size: 20.0,
              ),
              label: Text('Go to home'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.black
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                print('Outlined icon button');
              },
              icon: Icon(
                Icons.home,
              ),
              label: Text('Go to home'),
              style: OutlinedButton.styleFrom(
                  primary: Colors.black
              ),
            ),
          ],
        ),
      ),
    );
  }
}
