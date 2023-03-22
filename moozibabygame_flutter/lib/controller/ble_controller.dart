import 'dart:async';
import 'dart:convert';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:moozibabygame_flutter/controller/moozi_controller.dart';
import 'package:moozibabygame_flutter/util/constants.dart';
import 'package:moozibabygame_flutter/data.dart';
import 'package:moozibabygame_flutter/screen/game_screen.dart';

class BleController extends GetxController {
  static BleController get to => Get.find();

  final flutterReactiveBle = FlutterReactiveBle();

  StreamSubscription? streamSubscription;

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
    print('BleController Onit');
    Get.put(MooziController());
    scanForDevices();

    ever(grabPower, (_) => changeImage());
    super.onInit();
  }

  void sendData(String value) async {
    final characteristic = QualifiedCharacteristic(
      serviceId: UUID,
      characteristicId: RX,
      deviceId: bleId.value,
    );

    await flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: value.codeUnits);
  }

  void changeImage() {
    // if (grabPower.value == 0) {
    //   babyImage.value = 1;
    //   backgroundImage.value = 3;
    //   starImage = 'green'.obs;
    //   sendData('VM');
    // } else if (0 < grabPower.value && grabPower.value <= 2) {
    //   babyImage.value = 2;
    //   backgroundImage.value = 4;
    //   starImage = 'yellow'.obs;
    //   sendData('VM');
    // } else if (2 < grabPower.value && grabPower.value <= 4) {
    //   babyImage.value = 3;
    //   backgroundImage.value = 5;
    //   starImage = 'pink'.obs;
    //   sendData('VM');
    // } else {
    //   babyImage.value = 4;
    //   backgroundImage.value = 6;
    //   starImage = 'effect'.obs;
    //   // babyImage4 일때 진동 울리게 하기
    //   sendData('VB'); // 진동 종류
    //   sendData('VZ'); // 진동 울림
    //   sendData('KS');
    // }
    if (0 <= grabPower.value && grabPower.value <= 20) {
      babyImage.value = 1;
      backgroundImage.value = 3;
      starImage = 'green'.obs;
      MooziController.to.setVibrationPower('VM');
    } else if (20 < grabPower.value && grabPower.value <= 40) {
      babyImage.value = 2;
      backgroundImage.value = 4;
      starImage = 'yellow'.obs;
      MooziController.to.setVibrationPower('VM');
    } else if (40 < grabPower.value && grabPower.value <= 60) {
      babyImage.value = 3;
      backgroundImage.value = 5;
      starImage = 'pink'.obs;
      MooziController.to.setVibrationPower('VM');
    } else if (60 < grabPower.value && grabPower.value <= 100) {
      babyImage.value = 4;
      backgroundImage.value = 6;
      starImage = 'effect'.obs;
      // babyImage4 일때 진동 울리게 하기
      MooziController.to.setVibrationPower('VB');
      MooziController.to.startVibration(); // 진동 울림
    } else {
      babyImage.value = 1;
      backgroundImage.value = 3;
      starImage = 'green'.obs;
      MooziController.to.setVibrationPower('VM');
    }
  }

  void scanForDevices() {
    streamSubscription = flutterReactiveBle
        .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency)
        .where((event) => event.name.contains('moozi_023'))
        .listen((event) async {
          print(event);
          BleController.to.bleName.value = event.name;
          BleController.to.bleId.value = event.id;

          streamSubscription!.cancel();

          if (BleController.to.bleName.value != '') {
            print('블루투스 검색 성공 연결시도');
            connectToDevice();
          }
        }, onError: (error) {
          print('에러 메세지 : ${error.toString()}');
        });
  }

  Future<void> connectToDevice() async {
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
            // 블루투스 데이터 응답
            bleResponse();
            // 자이로모드 2D 실행
            MooziController.to.startGyro();
            // 악력 범위 설정
            MooziController.to.setGrabPower(0, 30);
            // 악력 정밀도? 위해 설정?
            // MooziController.to.getLoadCellInit();
            // MooziController.to.getLodadCellMiddle();
            await Future.delayed(Duration(milliseconds: 1000));
            Get.to(() => gameScreen());
            break;
          case DeviceConnectionState.disconnected:
            //do something for disconnected state
            print('연결 실패');
            connectToDevice();
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

        if (deltaX.abs() < 5 && x.abs() > 5 ||
            deltaY.abs() < 5 && y.abs() > 5) {
          state = 0;
          print(' ###### state : $state');
        }
        if (deltaX.abs() > 5 && x.abs() < 5 ||
            deltaY.abs() > 5 && y.abs() < 5) {
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
}
