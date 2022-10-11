import 'package:flutter/material.dart';

void main() => runApp(MyApp());

    class MyApp extends StatelessWidget {
      const MyApp({Key? key}) : super(key: key);
    
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'First app',
          theme: ThemeData(
            primarySwatch: Colors.blue
          ),
          home: MyHomePage(),
        );
      }
    }
    
    class MyHomePage extends StatelessWidget {
      const MyHomePage({Key? key}) : super(key: key);
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('First app'),
          ),
          body: Center(
            child: Column(
              children: [
                Text('Hello'),
                Text('Hello'),
                Text('Hello'),
              ],
            ),
          ),
        );
      }
    }
    