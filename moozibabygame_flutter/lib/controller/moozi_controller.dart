import 'package:get/get.dart';
import 'package:moozibabygame_flutter/controller/ble_controller.dart';
import 'package:moozibabygame_flutter/data.dart';

class MooziController extends GetxController {
  static MooziController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  void setGrabPower(int min, int max) {
    BleController.to.sendData('LL$min');
    BleController.to.sendData('LH$max');
    Grab.loadCellLowValue = min;
    Grab.loadCellHighValue = max;

    print('loadCellLowValue: ${Grab.loadCellLowValue}');
    print('loadCellHighValue: ${Grab.loadCellHighValue}');
  }

  void getLoadCellInit() {
    BleController.to.sendData('LI');
    print('LI');
  }

  void getLodadCellMiddle() {
    BleController.to.sendData('LM');
    print('LM');
  }

  void setVibrationPower(String vibrationMode){
    BleController.to.sendData(vibrationMode);
  }

  void setVibrationTime(int vibrationTime){
    BleController.to.sendData('VO$vibrationTime');
  }

  void setVibrationInterval(String vibrationInterval){
    BleController.to.sendData('VI$vibrationInterval');
  }

  void startVibration(){
    BleController.to.sendData('VZ');
  }

  void startGyro(){
    BleController.to.sendData('KS');
  }

  void stopGyro(){
    BleController.to.sendData('KT');
  }

}
