import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moozibabygame_flutter/controller/ble_controller.dart';
import 'package:moozibabygame_flutter/util/fade_transition.dart';

class gameScreen extends StatelessWidget {
  const gameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BleController());

    var sumX = 0;
    var sumY = 0;

    return Obx(
      () => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    'assets/bb_bg_${BleController.to.backgroundImage.value}.png'),
                fit: BoxFit.fill),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Positioned(
                      top: 50.h,
                      left: 30.w,
                      child: Image.asset(
                        BleController.to.starImage.value != 'effect'
                            ? 'assets/star_${BleController.to.starImage.value}_1.png'
                            : 'assets/${BleController.to.starImage.value}.png',
                      ),
                    ),
                    Positioned(
                      top: 150.h,
                      right: 5.w,
                      child: Image.asset(
                        BleController.to.starImage.value != 'effect'
                            ? 'assets/star_${BleController.to.starImage.value}_2.png'
                            : 'assets/${BleController.to.starImage.value}.png',
                        height: 100.h,
                        width: 70.w,
                      ),
                    ),
                    Positioned(
                      top: 300.h,
                      left: 5.w,
                      child: Image.asset(
                        BleController.to.starImage.value != 'effect'
                            ? 'assets/star_${BleController.to.starImage.value}_3.png'
                            : 'assets/${BleController.to.starImage.value}.png',
                        height: 100.h,
                        width: 70.w,
                      ),
                    ),
                    Positioned(
                      bottom: 200.h + BleController.to.gyroY.value.toDouble(),
                      left: 0 + BleController.to.gyroX.value.toDouble(),
                      right: 0,
                      child: Image.asset(
                        'assets/baby_${BleController.to.babyImage.value}.png',
                        height: 350.h,
                      ),
                    ),
                    Positioned(
                      bottom: 200.h,
                      left: 0,
                      right: 0,
                      child: Text(
                        '${BleController.to.babyImage.value}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50.sp,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50.h,
                      left: 0,
                      right: 0,
                      child: MyStatefulWidget(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
