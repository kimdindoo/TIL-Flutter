import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final flutterReactiveBle = FlutterReactiveBle();

StreamSubscription? _subscription;

StreamSubscription? _subscription2;

// late String foundDeviceId;

final storage = FlutterSecureStorage();

const DEVICE_ID = 'DEVICE_ID';

// FlutterSecureStorage? foundDeviceId;

// final servicesToDiscover = {
//   Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'): [
//     Uuid.parse('00001F10-8835-40B6-8651-5691F8630806'),
//     Uuid.parse('00001F11-8835-40B6-8651-5691F8630806')
//   ]
// };

final characteristicIdList = [
  Uuid.parse('00002a00-0000-1000-8000-00805f9b34fb'),
  Uuid.parse('00002a01-0000-1000-8000-00805f9b34fb'),
  Uuid.parse('00002a04-0000-1000-8000-00805f9b34fb'),
  Uuid.parse('00002aa6-0000-1000-8000-00805f9b34fb'),
  Uuid.parse('00002ac9-0000-1000-8000-00805f9b34fb'),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await storage.delete(key: DEVICE_ID);

  runApp(const MaterialApp(home: MyApp()));
}

void _ble_scan_status() {
  flutterReactiveBle.statusStream.listen((status) {
    if (BleStatus.poweredOff == status) {
      print('power off');
    } else if (BleStatus.ready == status) {
      print('ready ble');
    } else if (BleStatus.unauthorized == status) {
      print('unauthorized ble');
    }
  });
}

void _ble_scan_all_start() {
  _subscription = flutterReactiveBle.scanForDevices(
      withServices: [], scanMode: ScanMode.lowLatency).listen((device) {
    print(
        'detect device id : ${device.id} // device.rssi : ${device.rssi} // device.name : ${device.name}');
  }, onError: (e) {
    print('eeeeeeee:${e.toString()}');
  });
}

void _ble_scan_start() {
  _subscription = flutterReactiveBle
      .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency)
      .where((event) => event.name.contains('moozi_023'))
      .listen((device) async {
        print(
            'detect device id : ${device.id} // device.rssi : ${device.rssi} // device.name : ${device.name} // device.serviceUuids : ${device.serviceUuids}');

        await storage.write(key: DEVICE_ID, value: device.id);

        final foundDeviceId = await storage.read(key: DEVICE_ID);
        print(foundDeviceId);

        // if (foundDeviceId.isEmpty) {
        //   await storage.write(key: DEVICE_ID, value: device.id);
        // } else if(foundDeviceId.isNotEmpty) {
        //   await storage.delete(key: DEVICE_ID);
        //   await storage.write(key: DEVICE_ID, value: device.id);
        // }

        // foundDeviceId = device.id;
      }, onError: (e) {
        print('eeeeeeee:${e.toString()}');
      });
}

void _ble_scan_stop() async {
  await _subscription?.cancel();
  _subscription = null;
  print('ble stop');
}

void _ble_connect() async {
  String? foundDeviceId = await storage.read(key: DEVICE_ID);

  _subscription2 = flutterReactiveBle
      .connectToDevice(
    id: foundDeviceId!,
    // servicesWithCharacteristicsToDiscover: servicesToDiscover,
    connectionTimeout: const Duration(seconds: 20),
  )
      .listen((connectionState) {
    // Handle connection state updates

    print('블루트스 연결 성공');
    print(
        'connectionState.connectionState : ${connectionState.connectionState} // connectionState.deviceId : ${connectionState.deviceId}');
  }, onError: (dynamic error) {
    // Handle a possible error
  });
}

void _ble_read() async {
  String? foundDeviceId = await storage.read(key: DEVICE_ID);

  final characteristic = QualifiedCharacteristic(
    serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
    characteristicId: characteristicIdList[0], // mozi_023
    // characteristicId: characteristicIdList[1],
    // characteristicId: characteristicIdList[2],
    // characteristicId: characteristicIdList[3],
    // characteristicId: characteristicIdList[4],
    deviceId: foundDeviceId!,
  );
  final response = await flutterReactiveBle.readCharacteristic(characteristic);

  print(response);

  var decode = utf8.decode(response);

  print('decoding : $decode');
}

void _ble_write() async {
  String? foundDeviceId = await storage.read(key: DEVICE_ID);

  final characteristic = QualifiedCharacteristic(
    serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
    characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
    deviceId: foundDeviceId!,
  );

  List<int> bytes = utf8.encode('!ftm vibrator');
  print('encoding : $bytes');

  var decode = utf8.decode(bytes);
  print(decode);

  //
  flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
      value: bytes);

  // await flutterReactiveBle.writeCharacteristicWithResponse(characteristic, value: bytes);
}

void _ble_get_notification() async {
  String? foundDeviceId = await storage.read(key: DEVICE_ID);

  final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F10-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!);
  flutterReactiveBle.subscribeToCharacteristic(characteristic).listen((data) {
    print(data);

    var decode = utf8.decode(data);
    print('decoding : $decode');

    // String result = decode.replaceAll(RegExp('[^0-9\\s]'), ""); // 정규식 숫자만

    if (decode.substring(0, 1) == 'P') {
      String result = decode.replaceAll(RegExp('\\D'), ""); // 정규식 숫자만
      print('배터리 잔량 : $result');
    } else if (decode.substring(0, 1) == 'L') {
      String result = decode.replaceAll(RegExp('\\D'), ""); // 위아래 똑같음
      double d = double.parse(result);
      double percentage = (d * 100.0 * 100).round() / 100.0;
      double kg = (percentage / 2.0 * 100).round() / 100.0;
      double lb = (kg * 2.2046 * 100) / 100.0;

      print('악력 크기 : $percentage % $kg kg $lb lb');
    }
  }, onError: (dynamic error) {});
}

void _ble_write_battery() async {
  String? foundDeviceId = await storage.read(key: DEVICE_ID);

  final characteristic = QualifiedCharacteristic(
    serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
    characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
    deviceId: foundDeviceId!,
  );

  List<int> bytes = ascii.encode('PC');
  print('encoding : $bytes');

  flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
      value: bytes);

  // await flutterReactiveBle.writeCharacteristicWithResponse(characteristic, value: bytes);
}

void _ble_ledOn() async {
  String? foundDeviceId = await storage.read(key: DEVICE_ID);

  final characteristic = QualifiedCharacteristic(
    serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
    characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
    deviceId: foundDeviceId!,
  );

  List<int> bytes = ascii.encode('WO');
  print('encoding : $bytes');

  flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
      value: bytes);
}

void _ble_ledOff() async {
  String? foundDeviceId = await storage.read(key: DEVICE_ID);

  final characteristic = QualifiedCharacteristic(
    serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
    characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
    deviceId: foundDeviceId!,
  );

  List<int> bytes = ascii.encode('WF');
  print('encoding : $bytes');

  flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
      value: bytes);
}

void _ble_setVibrationOption(String value) async {
  String? foundDeviceId = await storage.read(key: DEVICE_ID);

  final characteristic = QualifiedCharacteristic(
    serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
    characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
    deviceId: foundDeviceId!,
  );

  List<int> bytes = ascii.encode(value);
  print('encoding : $bytes');

  flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
      value: bytes);
}

void _ble_setVibrationPower() async {
  String? foundDeviceId = await storage.read(key: DEVICE_ID);

  final characteristic = QualifiedCharacteristic(
    serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
    characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
    deviceId: foundDeviceId!,
  );

  List<int> bytes = ascii.encode('VS0');
  print('encoding : $bytes');

  flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
      value: bytes);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _texts = ['VA', 'VB', 'VC', 'VD', 'VM'];

  late List<bool> _isChecked;

  String sendVibrationOption = 'VA';

  // late List<int> _checkedTime;

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(_texts.length, false);
    // _checkedTime = [];
  }

  // Android Uuid 가져오기
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('BLE Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // FutureBuilder<String?>(
            //   future: _methodChannel.invokeMethod<String?>('getId'),
            //   builder: (_, snapshot) {
            //     if (snapshot.hasData) {
            //       print(snapshot.data);
            //       return Text('${snapshot.data}');
            //     }
            //
            //     return const CircularProgressIndicator();
            //   },
            // ),
            ElevatedButton(
              onPressed: () {
                _ble_scan_status();
              },
              child: Text('블루투스 연결 상태 확인'),
            ),
            ElevatedButton(
              onPressed: () {
                _ble_scan_all_start();
              },
              child: Text('블루투스 전체 검색'),
            ),
            ElevatedButton(
              onPressed: () {
                _ble_scan_start();
              },
              child: Text('블루투스 특정 검색'),
            ),
            ElevatedButton(
              onPressed: () {
                _ble_scan_stop();
              },
              child: Text('블루투스 검색 중지'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () {
                _ble_connect();
              },
              child: Text('블루투스 연결'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await _subscription2?.cancel();
              },
              child: Text('블루투스 연결 중지'),
            ),
            ElevatedButton(
              onPressed: () {
                _ble_read();
              },
              child: Text('블루투스 읽기'),
            ),
            ElevatedButton(
              onPressed: () {
                _ble_write();
              },
              child: Text('블루투스 쓰기'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                _ble_get_notification();
              },
              child: Text('블루투스 알림 정보 확인'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent),
              onPressed: () {
                _ble_write_battery();
              },
              child: Text('블루투스 배터리 잔량 확인'),
            ),
            ElevatedButton(
              onPressed: () {
                _ble_ledOn();
              },
              child: Text('블루투스 led ON'),
            ),
            ElevatedButton(
              onPressed: () {
                _ble_ledOff();
              },
              child: Text('블루투스 led OFF'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              onPressed: () {},
              child: Text('진동 종류 설정'),
            ),
            _checkBoxVibration(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              onPressed: () {
                _ble_setVibrationPower();
              },
              child: Text('진동 세기 설정'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkBoxVibration() {
    String v = 'VA';

    return Column(
      children: [
        SizedBox(
          height: 350,
          child: ListView.builder(
            itemCount: _texts.length,
            itemBuilder: (context, index) {
              return Card(
                child: CheckboxListTile(
                  title: Text(_texts[index]),
                  value: _isChecked[index],
                  onChanged: (val) {
                    setState(() {
                      _isChecked[index] = val!;

                      sendVibrationOption = _texts[index];

                      print(sendVibrationOption);
                      print(index);
                      // if(_isChecked[index] == true){
                      //   _checkedTime.add(index);
                      // } else {
                      //   _checkedTime.remove(index);
                      // }
                    });
                  },
                ),
              );
            },
          ),
        ),
        Container(
          child: ElevatedButton(
            child: Text('설정'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
            onPressed: () {
              // print(_checkedTime);
              print(sendVibrationOption);
              _ble_setVibrationOption(sendVibrationOption);
            },
          ),
        )
      ],
    );
  }
}
