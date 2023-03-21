import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:moozibabygame_flutter/controller/ble_controller.dart';
import 'package:moozibabygame_flutter/data.dart';
import 'package:moozibabygame_flutter/screen/game_screen.dart';
import 'package:permission_handler/permission_handler.dart';

final flutterReactiveBle = FlutterReactiveBle();
late StreamSubscription _streamSubscription;

void main() async {
  runApp(MyApp());

  await Permission.bluetoothScan.request();
  await Permission.bluetoothConnect.request();

  _scanForDevices();
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final BleController bleController = Get.put(BleController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (BuildContext context, child) {
          return GetMaterialApp(
            home: HomeScreen(),
          );
        });
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              () => BleController.to.bleLoading.value == true
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
                                Get.to(() => gameScreen());
                              },
                              title: Obx(
                                () => BleController.to.bleName.value != ''
                                    ? Text(
                                        '${BleController.to.bleName.value}',
                                        textAlign: TextAlign.center,
                                      )
                                    : SpinKitCircle(
                                        color: Colors.green,
                                      ),
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
                  : SpinKitCircle(
                      color: Colors.green,
                      size: 320.h,
                    ),
            ),
            SizedBox(
              height: 60.h,
            ),
            Image.asset(
              'assets/logo_moozi.png',
              height: 45.h,
            ),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }
}

void _scanForDevices() {
  _streamSubscription = flutterReactiveBle
      .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency)
      .where((event) => event.name.contains('moozi_023'))
      .listen((event) async {
        print(event);
        BleController.to.bleName.value = event.name;
        BleController.to.bleId.value = event.id;

        _streamSubscription.cancel();

        if (BleController.to.bleName.value != '') {
          print('블루투스 검색 성공 연결시도');
          _connectToDevice();
        }
      }, onError: (error) {
        print('에러 메세지 : ${error.toString()}');
      });
}

Future<void> _connectToDevice() async {
  flutterReactiveBle
      .connectToDevice(
    id: BleController.to.bleId.value,
    connectionTimeout: const Duration(seconds: 20),
    // withServices: [],
    // prescanDuration: const Duration(seconds: 5),
  )
      .listen(
    (connectionState) async {
      print(connectionState.connectionState);

      switch (connectionState.connectionState) {
        case DeviceConnectionState.connected:
          //do something for connected state
          BleController.to.bleLoading.value = true;
          print(BleController.to.bleLoading.value);
          print('연결 성공');
          bleResponse();
          await Future.delayed(Duration(milliseconds: 1000));
          Get.to(() => gameScreen());
          break;
        case DeviceConnectionState.disconnected:
          //do something for disconnected state
          print('연결 실패');
          break;
        case DeviceConnectionState.connecting:
          //do something for connecting state
          print('연결중');
          break;
        case DeviceConnectionState.disconnecting:
          //do something for connecting state
          print('연결 실패중');
          break;
      }
    },
    onError: (error) {
      print('에러 메세지 : ${error.toString()}');
      _connectToDevice();
    },
  );
}

void bleResponse() async {
  final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F10-8835-40B6-8651-5691F8630806'),
      deviceId: BleController.to.bleId.value);
  flutterReactiveBle.subscribeToCharacteristic(characteristic).listen(
      (data) async {
    // print(data);

    var decode = utf8.decode(data);
    // print(decode);

    if (decode.substring(0, 1) == 'P') {
      String result = decode.replaceAll(RegExp('\\D'), ""); // 정규식 숫자만
      print('배터리 잔량 : $result');

      Battery.power = result;
    } else if (decode.substring(0, 1) == 'L') {
      String result = decode.replaceAll(RegExp('\\D'), "");

      // 악력 없으면 로그 x - 테스트시 로그 지저분해서
      // if (decode.substring(0, 1) == 'L' && 16267000 < int.parse(result)) {
      //   return null;
      // }

      var low = 0.0;
      var high = 0.0;

      var loadCellInitVal = 16267000;
      var loadCellMaxVal = 12600000;

      if (Grab.loadCellLowValue + (100 - Grab.loadCellHighValue) <= 100) {
        if (Grab.loadCellLowValue != 0) {
          low = (loadCellInitVal - loadCellMaxVal).toDouble() *
              Grab.loadCellLowValue.toDouble() /
              100.0;
        }
        if (Grab.loadCellHighValue != 100) {
          high = (loadCellInitVal - loadCellMaxVal).toDouble() *
              (100 - Grab.loadCellHighValue).toDouble() /
              100;
        }
      }

      final maxValue = loadCellMaxVal.toDouble() + high;
      final minValue = loadCellInitVal.toDouble() - low;

      double tempVal = double.parse(result);
      var value = tempVal - maxValue;

      var res = 1.0 - value / (minValue - maxValue);
      if (res < 0.0) {
        res = 0.0;
      }
      if (res > 1.0) {
        res = 1.0;
      }

      BleController.to.grabPower.value =
          ((res * 100.0 * 100).round() / 100.0).round().toInt();

      Grab.percentage = (res * 100.0 * 100).round() / 100.0;
      Grab.kg = (Grab.percentage / 2.0 * 100).round() / 100.0;
      Grab.lb = (Grab.kg * 2.2046 * 100).round() / 100.0;

      Grab.grabPower = [Grab.percentage, Grab.kg, Grab.lb];

      print('악력 크기 : ${Grab.percentage} % ${Grab.kg} kg ${Grab.lb} lb');
      print(
          'BleController.to.grabPower.value : ${BleController.to.grabPower.value}');
    } else if (decode.substring(0, 2) == 'C1') {
      print('구성 리스트 outCallback1 가져오기 성공');
      String str = decode.substring(3, 14);
      List<String> result = str.split(',');
      print(result);
    } else if (decode.substring(0, 2) == 'C2') {
      print('구성 리스트 outCallback2 가져오기 성공');
      String str = decode.substring(3, 14);
      List<String> result = str.split(',');
      print(result);
    } else if (decode.substring(0, 1) == 'S') {
      print('만보기 카운트 가져오기');
      String result = decode.replaceAll(RegExp('\\D'), ""); // 정규식 숫자만
      OnWalk.count = result;
      print(result);
    } else if (decode.substring(0, 1) == 'D') {
      // 2D 모드

      var state = 1;
      if (decode.substring(0, 2) == 'D[') {
        // 움직이는 동안
        state = 1;
      } else if (decode.substring(0, 2) == 'DS') {
        // 움직이기 시작할때
        state = 0;
      } else if (decode.substring(0, 2) == 'DE') {
        // 움직임이 멈출때
        state = 2;
      }

      var temp = decode.split('[');
      var temp2 = temp[1].split("]");
      var substr = temp2[0];
      var array = substr.split(",");

      var x = int.parse(array[0]);
      var y = int.parse(array[1]);

      var deltaX = 0;
      var deltaY = 0;

      if (deltaX.abs() < 5 && x.abs() > 5 || deltaY.abs() < 5 && y.abs() > 5) {
        state = 0;
        print(' ###### state : $state');
      }
      if (deltaX.abs() > 5 && x.abs() < 5 || deltaY.abs() > 5 && y.abs() < 5) {
        state = 2;
        print(' ###### state : $state');
      }

      deltaX = x;
      deltaY = y;

      Gyro.x = x;
      Gyro.y = y;

      BleController.to.gyroX.value = x;
      BleController.to.gyroY.value = y;

      print('2D 모드 : x : ${Gyro.x} / y : ${Gyro.y}');

      Gyro.dataXY = [x, y];

      // onDeltaXY(x, y, state);

    } else if (decode.substring(0, 2) == 'A[') {
      // 3D 모드
      // processAcc(decode);
    } else if (decode.substring(0, 2) == 'G[') {
      // 3D 모드
      // processGyro(decode);
    } else {
      print('decoding : $decode');
    }
  }, onError: (dynamic error) {});
}
