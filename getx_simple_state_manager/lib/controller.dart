import 'package:get/get.dart';

class Controller extends GetxController{

  int _x = 0;
  int get x => _x;

  void increment(){
    _x++;
    update();
  }

}