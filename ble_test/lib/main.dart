import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

final flutterReactiveBle = FlutterReactiveBle();

StreamSubscription? _subscription;

StreamSubscription? _subscription2;

String foundDeviceId = '00:A0:50:00:00:23';

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

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(home: MyApp()));
}

void _ble_scan_start() {
  _subscription = flutterReactiveBle
      .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency)
      .where((event) => event.name.contains('moozi_023'))
      .listen((device) {
        print(
            'detect device id : ${device.id} // device.rssi : ${device.rssi} // device.name : ${device.name} // device.serviceUuids : ${device.serviceUuids}');
        foundDeviceId = device.id;
      }, onError: (e) {
        print('eeeeeeee:${e.toString()}');
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

void _ble_scan_stop() async {
  await _subscription?.cancel();
  _subscription = null;
  print('ble stop');
}

void _ble_connect() {
  print(foundDeviceId);

  _subscription2 = flutterReactiveBle
      .connectToDevice(
    id: foundDeviceId,
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
  final characteristic = QualifiedCharacteristic(
    serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
    characteristicId:Uuid.parse('00001F10-8835-40B6-8651-5691F8630806'),
    deviceId: foundDeviceId,
  );
  final response = await flutterReactiveBle.readCharacteristic(characteristic);

  print(response);
}

void _ble_write() async {
  final characteristic = QualifiedCharacteristic(
    serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
    characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
    // characteristicId: characteristicIdList[0],
    deviceId: foundDeviceId,
  );

  List<int> bytes = utf8.encode('!ftm vibrator');
  print('encoding : $bytes');

  //
  flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
      value: bytes);


  await flutterReactiveBle.writeCharacteristicWithResponse(characteristic, value: bytes);
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Android Uuid 가져오기
  // static const MethodChannel _methodChannel = MethodChannel('deviceId');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Example'),
      ),
      body: Column(
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
            onPressed: () {
              _ble_connect();
            },
            child: Text('블루투스 연결'),
          ),
          ElevatedButton(
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
            onPressed: () {
              _ble_scan_status();
            },
            child: Text('블루투스 연결 상태 확인'),
          ),
        ],
      ),
    );
  }
}
