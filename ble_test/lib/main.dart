import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

final flutterReactiveBle = FlutterReactiveBle();

StreamSubscription? _subscription;

var deviceId;
var deviceServiceUuids = [Uuid.parse('00001f00-8835-40b6-8651-5691f8630806')];
final servicesToDiscover = {
  Uuid.parse('00001f00-8835-40b6-8651-5691f8630806'): [
    Uuid.parse('00001F10-8835-40B6-8651-5691F8630806'),
    Uuid.parse('00001F11-8835-40B6-8651-5691F8630806')
  ]
};

//00001F10-8835-40B6-8651-5691F8630806

var characteristicUuid = Uuid.parse('00001F10-8835-40B6-8651-5691F8630806');
var characteristicUuid2 = Uuid.parse('00001F11-8835-40B6-8651-5691F8630806');

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(home: MyApp()));
}

void _ble_scan_start() {
  _subscription = flutterReactiveBle
      .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency)
      .where((event) => event.name.contains('WOAWOA'))
      .listen((device) {
        print(
            'detect device id : ${device.id} // device.rssi : ${device.rssi} // device.name : ${device.name} // device.serviceUuids : ${device.serviceUuids}  // device.serviceData : ${device.serviceData} // device.manufacturerData :${device.manufacturerData}');
        deviceId = device.id;
        deviceServiceUuids = device.serviceUuids;
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

void _ble_scan_stop() {
  _subscription?.cancel();
  _subscription = null;
}

void _ble_connect() {
  flutterReactiveBle
      .connectToDevice(
    id: deviceId,
    servicesWithCharacteristicsToDiscover: servicesToDiscover,
    connectionTimeout: const Duration(seconds: 20),
  )
      .listen((connectionState) {
    // Handle connection state updates
  }, onError: (dynamic error) {
    // Handle a possible error
  });
}

void _ble_read() async {
  final characteristic = QualifiedCharacteristic(
      serviceId: deviceServiceUuids.first,
      characteristicId: characteristicUuid2,
      deviceId: deviceId);
  final response = await flutterReactiveBle.readCharacteristic(characteristic);

  print(response);
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
  static const MethodChannel _methodChannel = MethodChannel('deviceId');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<String?>(
            future: _methodChannel.invokeMethod<String?>('getId'),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return Text('${snapshot.data}');
              }

              return const CircularProgressIndicator();
            },
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
            child: Text('블루투스 중지'),
          ),
          ElevatedButton(
            onPressed: () {
              _ble_connect();
            },
            child: Text('블루투스 연결'),
          ),
          ElevatedButton(
            onPressed: () {
              _ble_read();
            },
            child: Text('블루투스 읽기'),
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
