import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moozibabygame_flutter/controller/ble_controller.dart';

class gameScreen extends StatefulWidget {
  const gameScreen({Key? key}) : super(key: key);

  @override
  State<gameScreen> createState() => _gameScreenState();
}

class _gameScreenState extends State<gameScreen> {
  String babyName = 'baby1';
  List<String> babyNames = ['baby1', 'baby2', 'baby3', 'baby4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bbBg3.png'), fit: BoxFit.fill),
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
                    child: Image.asset('assets/starGreen1.png'),
                  ),
                  Positioned(
                    top: 150.h,
                    right: 5.w,
                    child: Image.asset(
                      'assets/starGreen1.png',
                      height: 100.h,
                      width: 70.w,
                    ),
                  ),
                  Positioned(
                    top: 300.h,
                    left: 5.w,
                    child: Image.asset(
                      'assets/starGreen1.png',
                      height: 100.h,
                      width: 70.w,
                    ),
                  ),
                  Obx(
                    () => Positioned(
                      bottom: 200.h,
                      left: 0,
                      right: 0,
                      child: babyImage(BleController.to.babayImage.value),
                    ),
                  ),
                  Positioned(
                    bottom: 50.h,
                    left: 0,
                    right: 0,
                    child: Image.asset('assets/invalidName.png'),
                  ),
                ],
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       for (int i = 0, len = babyNames.length; i < len; i++) {
            //         if (babyName == babyNames[i]) {
            //           if (i == len - 1) {
            //             babyName = babyNames[0];
            //           } else {
            //             babyName = babyNames[i + 1];
            //           }
            //           break;
            //         }
            //       }
            //     });
            //   },
            //   child: Text('이미지 바꾸기'),
            // ),
            // Image.asset('assets/invalidName.png'),
          ],
        ),
      ),
    );
  }

  Widget babyImage(int babyName) {
    return Image.asset(
      'assets/baby$babyName.png',
      height: 400.h,
      // width: 100.w,
    );
  }
}
