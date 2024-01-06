import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/screens/list_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future setLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          width: MediaQuery.of(context).size.width * 0.85,
          child: ElevatedButton(
            onPressed: () {
              setLogin().then((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ListScreen(),
                  ),
                );
              });
            },
            child: const Text('로그인'),
          ),
        ),
      ),
    );
  }
}
