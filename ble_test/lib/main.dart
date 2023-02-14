import 'dart:async';
import 'dart:convert';

import 'package:ble_test/screen/get_set_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/data.dart';

final flutterReactiveBle = FlutterReactiveBle();

StreamSubscription? _subscription;

StreamSubscription? _subscription2;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await storage.delete(key: DEVICE_ID);

  runApp(
    MaterialApp(
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('블루투스 연결'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: FoundDevice(),
            ),
          ],
        ),
      ),
    );
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
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        print('연결 성공');
      } else {
        print('연결 실패');
      }
    }, onError: (dynamic error) {});
  }
}

class FoundDevice extends StatefulWidget {
  const FoundDevice({Key? key}) : super(key: key);

  @override
  State<FoundDevice> createState() => _FoundDeviceState();
}

class _FoundDeviceState extends State<FoundDevice> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // param1: 최소 악력 설정 값, param2: 최대 악력 설정 값, param3: 진동 세기
  List<String> outCallback1 = [];

  // param1: 진동 동작 시간, param2: 진동 인터벌 시간, param3: 진동 모드(1: A,2: B, 3: C, 4: D, 0: 진동 없음)
  List<String> outCallback2 = [];

  List<DiscoveredDevice> discoveredDeviceList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DiscoveredDevice>>(
      stream: streamDeviceList(),
      builder: (BuildContext context,
          AsyncSnapshot<List<DiscoveredDevice>> snapshot) {
        print(snapshot.connectionState);

        return Center(
          child: ListView.separated(
            itemCount: discoveredDeviceList.length,
            itemBuilder: (context, index) {
              return listItem(discoveredDeviceList[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        );
      },
    );
  }

  Stream<List<DiscoveredDevice>> streamDeviceList() async* {
    _subscription = flutterReactiveBle
        .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency)
        .where((event) => event.name.contains('moozi_023'))
        .listen((device) {
          if (device.name.length > 2) {
            discoveredDeviceList.add(device);
          }
        }, onError: (e) {
          print('eeeeeeee:${e.toString()}');
        });

    // 일정 시간 후에 함수 실행
    // Timer(Duration(seconds: 5), () => _subscription!.cancel());

    for (int i = 0; i < 10; i++) {
      // if (i == 10) {
      //   throw Exception('i == 5');
      // }
      await Future.delayed(Duration(seconds: 1));

      yield discoveredDeviceList;
    }
  }

  Widget listItem(DiscoveredDevice d) {
    return ListTile(
      onTap: () {},
      title: Text(d.name),
      subtitle: Text(d.id),
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        child: Icon(
          Icons.bluetooth,
          color: Colors.white,
        ),
      ),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
        ),
        onPressed: () async {
          await storage.write(key: DEVICE_ID, value: d.id);

          flutterReactiveBle
              .connectToDevice(
            id: d.id,
            connectionTimeout: const Duration(seconds: 2),
          )
              .listen((connectionState) async {
            if (connectionState.connectionState ==
                DeviceConnectionState.connected) {
              print('## 연결 성공 ##');
              final foundDeviceId = await storage.read(key: DEVICE_ID);
              print('storage에 데이터 넣기 : $foundDeviceId');
              print('### 알림 정보 받기 ###');
              await _ble_get_notification();
              print('#### 기기 세팅값 받기 ####');
              getConfigList();
              getPower();
              getWalkCount();
              print('#### 다음 페이지 이동 ####');
              _movePage();
            }
          }, onError: (Object error) {});
        },
        child: Text('연결'),
      ),
    );
  }

  void _movePage() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GetSetDataScreen(
            outCallback1: outCallback1,
            outCallback2: outCallback2,
          ),
        ),
      );
    });
  }

  void getWalkCount() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('SR');
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }

  void getPower() async {
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

  Future _ble_get_notification() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final SharedPreferences prefs = await _prefs;

    final characteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
        characteristicId: Uuid.parse('00001F10-8835-40B6-8651-5691F8630806'),
        deviceId: foundDeviceId!);
    flutterReactiveBle.subscribeToCharacteristic(characteristic).listen(
        (data) async {
      print(data);

      var decode = utf8.decode(data);

      // 악력 없으면 로그 x - 테스트시 로그 지저분해서
      // if (decode.substring(0, 1) == 'L' && 16267000 < int.parse(result)) {
      //   return null;
      // }

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

        double percentage = (res * 100.0 * 100).round() / 100.0;
        double kg = (percentage / 2.0 * 100).round() / 100.0;
        double lb = (kg * 2.2046 * 100) / 100.0;

        print('악력 크기 : $percentage % $kg kg $lb lb');
      } else if (decode.contains('C1')) {
        print('구성 리스트 outCallback1 가져오기 성공');
        print(decode);

        print(decode.substring(3, 14));

        String str = decode.substring(3, 14);

        List<String> result = str.split(',');

        print(result);

        await prefs.setStringList('items', result);
        outCallback1 = prefs.getStringList('items')!;
      } else if (decode.contains('C2')) {
        print('구성 리스트 outCallback2 가져오기 성공');

        String str = decode.substring(3, 14);

        List<String> result = str.split(',');

        print(result);

        await prefs.setStringList('items2', result);
        outCallback2 = prefs.getStringList('items2')!;
      } else if (decode.contains('S')) {
        print('만보기 카운트 가져오기');
        String result = decode.replaceAll(RegExp('\\D'), ""); // 정규식 숫자만
        OnWalk.count = result;
        print(result);
      } else {
        print('decoding : $decode');
      }
    }, onError: (dynamic error) {});
  }
}
