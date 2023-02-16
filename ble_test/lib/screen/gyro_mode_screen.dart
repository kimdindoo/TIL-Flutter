import 'dart:convert';

import 'package:ble_test/common/ball.dart';
import 'package:ble_test/common/ball_test.dart';
import 'package:ble_test/common/data.dart';
import 'package:ble_test/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class GyroModeScreen extends StatelessWidget {
  const GyroModeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자이로모드 테스트'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container(
            //   height: 300,
            //   color: Colors.amber,
            //   child: CustomPaint(
            //     painter: MyPainter(),
            //     // foregroundPainter: MyForegroundPainter(),
            //   ),
            // ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              onPressed: () {
                startGyro();
              },
              child: Text('자이로 모드 켜기'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              onPressed: () {
                stopGyro();
                Gyro.dataXY = [0, 0];
              },
              child: Text('자이로 모드 끄기'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              onPressed: () {
                startGyro2D();
              },
              child: Text('자이로 모드 2D'),
            ),
            StreamGyroData(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              onPressed: () {
                startGyro3D();
              },
              child: Text('자이로 모드 3D'),
            ),
            StreamGyroData2(),
            SizedBox(
              height: 300,
              child: ReflectBall(
                ballRad: 20,
                mapXsize: MediaQuery.of(context).size.width,
                mapYsize: 300,
                xPosition: 100,
                yPosition: 200,
                xSpeed: 1,
                ySpeed: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startGyro2D() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('M2');
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }

  void startGyro3D() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('M3');
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }

  void startGyro() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('KS');
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }

  void stopGyro() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('KT');
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }
}

class StreamGyroData extends StatefulWidget {
  const StreamGyroData({Key? key}) : super(key: key);

  @override
  State<StreamGyroData> createState() => _StreamGyroDataState();
}

class _StreamGyroDataState extends State<StreamGyroData> {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 16.0,
    );
    return StreamBuilder<List>(
        stream: streamDataXY(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          // print(snapshot);
          if (!snapshot.hasData) {
            return Container();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '자이로 모드 좌표값',
                style: textStyle.copyWith(
                    fontWeight: FontWeight.w700, fontSize: 20.0),
              ),
              Text(
                '수신 상태 : ${snapshot.connectionState}',
                style: textStyle,
              ),
              Text(
                'x : ${snapshot.data![0]} / y : ${snapshot.data![1]}',
                style: textStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text('setState'),
                  ),
                ],
              )
            ],
          );
        });
  }

  Stream<List> streamDataXY() async* {
    for (int i = 0; i < 10000000; i++) {
      // if (i == 100) {
      //   throw Exception('i == 100');
      // }
      await Future.delayed(Duration(seconds: 1));

      yield Gyro.dataXY;
    }
  }
}

class StreamGyroData2 extends StatefulWidget {
  const StreamGyroData2({Key? key}) : super(key: key);

  @override
  State<StreamGyroData2> createState() => _StreamGyroData2State();
}

class _StreamGyroData2State extends State<StreamGyroData2> {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 16.0,
    );
    return StreamBuilder<List>(
        stream: streamDataXYZ(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          // print(snapshot);
          if (!snapshot.hasData) {
            return Container();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '자이로 모드 좌표값',
                style: textStyle.copyWith(
                    fontWeight: FontWeight.w700, fontSize: 20.0),
              ),
              Text(
                '수신 상태 : ${snapshot.connectionState}',
                style: textStyle,
              ),
              Text(
                'x : ${snapshot.data![0]} / y : ${snapshot.data![1]} / z : ${snapshot.data![2]}',
                style: textStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text('setState'),
                  ),
                ],
              )
            ],
          );
        });
  }

  Stream<List> streamDataXYZ() async* {
    for (int i = 0; i < 10000000; i++) {
      // if (i == 100) {
      //   throw Exception('i == 100');
      // }
      await Future.delayed(Duration(seconds: 1));

      yield Gyro.accXYZ;
    }
  }
}
