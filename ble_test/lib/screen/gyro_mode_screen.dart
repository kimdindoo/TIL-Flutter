import 'dart:convert';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          DnD(),
        ],
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
              // 특정 영역만 Indicator 보이게
              // Row(
              //   children: [
              //     Text(
              //       'Data : ${snapshot.data}',
              //       style: textStyle,
              //     ),
              //     if(snapshot.connectionState == ConnectionState.waiting)
              //       CircularProgressIndicator(
              //
              //       ),
              //   ],
              // ),
              Text(
                'Error : ${snapshot.error}',
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

class DnD extends StatefulWidget {
  DnD({Key? key}) : super(key: key);

  @override
  State<DnD> createState() => _DnDState();
}

class _DnDState extends State<DnD> {
  dynamic _balls;

  double xPos = 100;

  double yPos = 100;

  bool isClick = false;



  @override
  Widget build(BuildContext context) {
    _balls = _paint(
      xPosition: xPos,
      yPosition: yPos,
      ballRad: 20,

    );



    return GestureDetector(
      onHorizontalDragDown: (details) {
        setState(() {
          if (_balls.isBallRegion(details.localPosition.dx, details.localPosition.dy)) {
            isClick=true;
          }
        });
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          isClick=false;
        });
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          isClick=false;
        });
      },
      child: Container(
        width: 300,
        height: 300,
        color: Colors.lightBlueAccent,
        child: CustomPaint(
          painter: _balls,
        ),
      ),
    );
  }
}

class _paint extends CustomPainter {
  final xPosition;
  final yPosition;
  final ballRad;

  // bool isBallRegion(double checkX, double checkY){
  //   if((pow(xPosition-checkX, 2)+pow(yPosition-checkY, 2))<=pow(ballRad, 2)){
  //     return true;
  //   }
  //   return false;
  // }

  _paint({
    required this.xPosition,
    required this.yPosition,
    required this.ballRad,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.indigoAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path = Path();

    for (double i = 0; i < ballRad - 1; i++) {
      path.addOval(
          Rect.fromCircle(center: Offset(xPosition, yPosition), radius: i));
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;


}
