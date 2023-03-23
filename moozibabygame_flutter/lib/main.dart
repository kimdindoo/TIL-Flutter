import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:moozibabygame_flutter/controller/ble_controller.dart';
import 'package:moozibabygame_flutter/screen/game_screen.dart';
import 'package:moozibabygame_flutter/util/logo_fade_transition.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.bluetoothScan.request();
  await Permission.bluetoothConnect.request();

  runApp(MyApp());

  // BleController.to.scanForDevices();
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (BuildContext context, child) {
          return GetMaterialApp(
            home: HomeScreen(),
            // initialBinding: BindingsBuilder(
            //   () {
            //     Get.put(BleController(), permanent: true);
            //   },
            // )
          );
        });
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BleController());
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bb_bg_1.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 85.h,
            ),
            Image.asset(
              'assets/logo.png',
              height: 180.h,
            ),
            SizedBox(
              height: 75.h,
            ),
            Obx(
              () => BleController.to.bleLoading == true
                  ? Container(
                      height: 325.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/listbox.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: ScrollConfiguration(
                        behavior:
                            const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                Get.to(() => GameScreen());
                              },
                              title: Text(
                                '${BleController.to.bleName.value}',
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 70.w),
                              child: SizedBox(
                                height: 1.h,
                                child: Container(
                                  color: Colors.grey[300],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Container(
                      height: 325.h,
                    ),
            ),
            logoFade(),
            // Image.asset(
            //   'assets/logo_moozi.png',
            //   height: 45.h,
            // ),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }
}
