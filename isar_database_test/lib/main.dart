import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:isar_database_test/model/email.dart';
import 'package:isar_database_test/model/email.dart';
import 'package:isar_database_test/model/user_model.dart';
import 'package:isar_database_test/screen/home_screen.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());

  var box = await Hive.openBox('testBox');

  var userBox = await Hive.openBox<UserModel>('userBox');

  var persons = await Hive.openBox('persons');

  print(userBox.values);

  // box.put('name', 'kim');
  //
  // print('Name : ${box.get('kim')}');
  //
  // print('keys : ${box.keys.toList()}');
  // print('values : ${box.values.toList()}');

  final isar = await Isar.open([UserSchema]);

  final newUser = User()..name = 'kim'..age = 28;
  final newUser2 = User()..name = 'yang'..age = 28;

  // await isar.writeTxn(() async {
  //   await isar.users.put(newUser);
  //   await isar.users.put(newUser2);
  // });
  //
  // final existingUser = await isar.users.get(newUser2.id);
  //
  // print(existingUser!.id);
  //
  // await isar.writeTxn(() async {
  //   await isar.users.delete(existingUser.id!);
  // });

  final users = await isar.users.get(4);

  print(users);

  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}
