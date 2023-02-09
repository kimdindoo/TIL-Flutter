import 'dart:async';
import 'dart:convert';

import 'package:ble_test/screen/get_set_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/data.dart';

final flutterReactiveBle = FlutterReactiveBle();

StreamSubscription? _subscription;

StreamSubscription? _subscription2;

// late String foundDeviceId;

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

  // SharedPreferences Test

  // final prefs = await SharedPreferences.getInstance();
  // final List<String>? items = prefs.getStringList('items');
  // print(items![0]);

  await storage.delete(key: DEVICE_ID);

  runApp(
    MaterialApp(
      theme: ThemeData(
          // useMaterial3: true,
          // colorSchemeSeed: Colors.indigo,
          ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<String> items = ['50', '0', '0'];
  List<String> items2 = ['50', '0', '0'];

  @override
  void initState() {
    super.initState();
  }

  // Android Uuid 가져오기
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('BLE Test'),
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => GetSetDataScreen(data),
                //   ),
                // );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GetSetDataScreen(
                      data: items,
                      data2: items2,
                    ),
                  ),
                );
              },
              child: Text('데이터 송수신 페이지 이동'),
            ),
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
              child: Text('블루투스 특정(moozi_023) 검색'),
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
          ],
        ),
      ),
    );
  }

  void getConfigList() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('CL');
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
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
      print(
          '블루투스 연결 상태: ${connectionState.connectionState} // connectionState.deviceId : ${connectionState.deviceId}');

      if (connectionState.connectionState == DeviceConnectionState.connected) {
        print('## 연결 성공 ##');
        _ble_get_notification();
        print('알림 정보 받기 실행');
        getConfigList();
        // print('화면 이동');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => GetSetDataScreen(
        //       data: items,
        //     ),
        //   ),
        // );
      } else {
        print('연결 실패');
      }
    }, onError: (dynamic error) {
      // Handle a possible error
    });
  }

  void _ble_read() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: characteristicIdList[0], // moozi_023
      // characteristicId: characteristicIdList[1],
      // characteristicId: characteristicIdList[2],
      // characteristicId: characteristicIdList[3],
      // characteristicId: characteristicIdList[4],
      deviceId: foundDeviceId!,
    );
    final response =
        await flutterReactiveBle.readCharacteristic(characteristic);

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

    final SharedPreferences prefs = await _prefs;

    final characteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
        characteristicId: Uuid.parse('00001F10-8835-40B6-8651-5691F8630806'),
        deviceId: foundDeviceId!);
    flutterReactiveBle.subscribeToCharacteristic(characteristic).listen(
        (data) async {
      // print(data);

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
      } else if (decode.contains('C1')) {
        print('구성 리스트 C1 가져오기 성공');
        print(decode);

        print(decode.substring(3, 14));

        String str = decode.substring(3, 14);

        List<String> result = str.split(',');

        print(result);

        await prefs.setStringList('items', result);
        // final List<String>? items = prefs.getStringList('items');
        items = prefs.getStringList('items')!;
      } else if (decode.contains('C2')) {
        print('구성 리스트 C2 가져오기 성공');

        String str = decode.substring(3, 14);

        List<String> result = str.split(',');

        print(result);

        await prefs.setStringList('items2', result);
        items2 = prefs.getStringList('items2')!;
      } else {
        print(decode);
      }
    }, onError: (dynamic error) {});
  }
}
