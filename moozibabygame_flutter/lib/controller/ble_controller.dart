import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BleController extends GetxController {
  static BleController get to => Get.find();

  var bleLoading = false.obs;
  var bleName = ''.obs;
  var bleId = ''.obs;

  var grabPower = 0.obs;

  var babyImage = 1.obs;
  var backgroundImage = 3.obs;
  var starImage = 'green'.obs;

  var gyroX = 0.obs;
  var gyroY = 0.obs;

  @override
  void onInit() {
    ever(grabPower, (_) => changeImage());
    super.onInit();
  }

  void changeImage() {
    if (grabPower.value == 0) {
      babyImage.value = 1;
      backgroundImage.value = 3;
      starImage = 'green'.obs;
    } else if (0 < grabPower.value && grabPower.value <= 2) {
      babyImage.value = 2;
      backgroundImage.value = 4;
      starImage = 'yellow'.obs;
    } else if (2 < grabPower.value && grabPower.value <= 4) {
      babyImage.value = 3;
      backgroundImage.value = 5;
      starImage = 'pink'.obs;
    } else {
      babyImage.value = 4;
      backgroundImage.value = 6;
      starImage = 'effect'.obs;
    }
  }
}
