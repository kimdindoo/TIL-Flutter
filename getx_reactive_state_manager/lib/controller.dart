import 'package:get/get.dart';
import 'package:getx_reactive_state_manager/Model.dart';

class Controller extends GetxController{
  final person = Person().obs;

  void updateInfo(){
    person.update((val) {
      val?.age++;
      val?.name = 'Dindoo';
    });
  }
}