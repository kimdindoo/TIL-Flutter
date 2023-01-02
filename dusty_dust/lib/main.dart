import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/screen/home_screen.dart';
import 'package:dusty_dust/screen/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const testBox = 'test';

void main() async {
   await Hive.initFlutter();

   Hive.registerAdapter<StatModel>(StatModelAdapter());
   Hive.registerAdapter<ItemCode>(ItemCodeAdapter());

   await Hive.openBox(testBox);

   for(ItemCode itemCode in ItemCode.values){
     await Hive.openBox(itemCode.name);
   }

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'sunflower',
      ),
      home: TestScreen(),
    ),
  );
}
