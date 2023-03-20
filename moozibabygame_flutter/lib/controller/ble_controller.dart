import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BleController extends GetxController {
  static BleController get to => Get.find();

  var bleLoading = false.obs;
  var bleName = ''.obs;
  var bleId = ''.obs;

  var grabPower = 0.0.obs;

  var babayImage = 1.obs;

  @override
  void onInit() {
    ever(grabPower, (_) => setImage(grabPower.value));
    super.onInit();
  }

  void setImage(double power) {
    if(power > 0.0) {
      babayImage = 1.obs;
      print(babayImage.value);
    } else if (power > 5.0) {
      babayImage = 2.obs;
      print(babayImage.value);
    } else if (power > 8.0) {
      babayImage = 3.obs;
    } else {
      babayImage = 4.obs;
    }
  }
}
