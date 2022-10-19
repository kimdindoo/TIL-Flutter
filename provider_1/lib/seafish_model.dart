import 'package:flutter/material.dart';

class SeaFishModel with ChangeNotifier{
  final String name;
  int tunaNumber;
  final String size;

  SeaFishModel({required this.name, required this.tunaNumber, required this.size});

  void changeSeaFishNumber(){
    tunaNumber++;
    notifyListeners();
  }
}