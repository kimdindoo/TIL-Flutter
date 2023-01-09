import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:riot_api/repository/user_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    UserRepository.fetchData();

    return Scaffold(
      body: Center(
        child: Text('HomeScreen'),
      ),
    );
  }
}
