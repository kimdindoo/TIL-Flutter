import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moozibabygame_flutter/controller/ble_controller.dart';
import 'package:moozibabygame_flutter/util/baby_rotation.dart';
import 'package:moozibabygame_flutter/util/explaintion_fade_transition.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BleController());

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
                    // // 맨아래 좌측 노란 별
                    // Positioned(
                    //   bottom: 0.h,
                    //   left: 0.w,
                    //   child: Image.asset(
                    //     'assets/star_yellow_3.png',
                    //   ),
                    // ),
                    // // 맨위 좌측 노란 별
                    // Positioned(
                    //   bottom: 765.h,
                    //   left: 0.w,
                    //   child: Image.asset(
                    //     'assets/star_yellow_3.png',
                    //   ),
                    // ),
                    BabyRotation(),
                    BleController.to.explanation.value == true
                        ? ExplaintionFade()
                        : Container(),
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
