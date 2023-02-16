import 'dart:async';
import 'dart:convert';

import 'package:ble_test/screen/get_set_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/data.dart';

final flutterReactiveBle = FlutterReactiveBle();

// param1: 최소 악력 설정 값, param2: 최대 악력 설정 값, param3: 진동 세기
List<String> outCallback1 = ['0', '0', '0'];

// param1: 진동 동작 시간, param2: 진동 인터벌 시간, param3: 진동 모드(1: A,2: B, 3: C, 4: D, 0: 진동 없음)
List<String> outCallback2 = ['0', '0', '0'];

List<DiscoveredDevice> discoveredDeviceList = [];

// 블루투스 기기 리스트에 중복 저장 x
List<DiscoveredDevice> uniqueDeviceList = [];

List<String> gyro = [];

bool isChecked = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              print('refresh cliked');
              // isChecked = true;
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              print('ssetting cliked');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => GetSetDataScreen(
                      outCallback1: outCallback1, outCallback2: outCallback2)));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if(isChecked == true)
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: FoundDevice(),
            ),
          ],
        ),
      ),
    );
  }
}

class FoundDevice extends StatefulWidget {
  const FoundDevice({Key? key}) : super(key: key);

  @override
  State<FoundDevice> createState() => _FoundDeviceState();
}

class _FoundDeviceState extends State<FoundDevice> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DiscoveredDevice>>(
      stream: streamDeviceList(),
      builder: (BuildContext context,
          AsyncSnapshot<List<DiscoveredDevice>> snapshot) {
        print(snapshot.connectionState);

        return Center(
          child: ListView.separated(
            itemCount: uniqueDeviceList.length,
            itemBuilder: (context, index) {
              return listItem(uniqueDeviceList[index]);
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
    flutterReactiveBle
        .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency)
        // .where((event) => event.name.contains('moozi_023'))
        .listen((device) {
      if (device.name.length > 2) {
        discoveredDeviceList.add(device);
        var seen = Set<String>();
        uniqueDeviceList = discoveredDeviceList
            .where((device) => seen.add(device.id))
            .toList();
      }
    }, onError: (e) {
      print('eeeeeeee:${e.toString()}');
    });

    // 일정 시간 후에 함수 실행
    // Timer(Duration(seconds: 5), () => _subscription!.cancel());

    for (int i = 0; i <= 5; i++) {
      // if (i == 10) {
      //   throw Exception('i == 5');
      // }
      await Future.delayed(Duration(seconds: 1));

      yield uniqueDeviceList;
    }
  }

  Widget listItem(DiscoveredDevice d) {
    return ListTile(
      onTap: () {
        // streamDeviceList();
        print(d.id);
      },
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
            print('블루투스 연결 상태 : ${connectionState.connectionState}');

            if (connectionState.connectionState ==
                DeviceConnectionState.connected) {
              print('## 연결 성공 ##');
              final foundDeviceId = await storage.read(key: DEVICE_ID);
              print('storage에 데이터 넣기 : $foundDeviceId');
              print('### 알림 정보 받기 ###');
              _ble_get_notification();
              print('#### 기기 세팅값 받기 ####');
              getConfigList();
              getPower();
              getWalkCount();
              // print('#### 다음 페이지 이동 ####');
              _showDialog();
              _movePage();
            } else if (connectionState.connectionState ==
                DeviceConnectionState.disconnected) {
              _showDialog2();
            }
          }, onError: (Object error) {});
        },
        child: Text('연결'),
      ),
    );
  }

  void _showDialog2() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("연결 실패"),
          actions: [
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("연결 성공"),
          content: Text("설정하면으로 이동합니다."),
          // actions: <Widget>[
          // TextButton(
          //   child: Text("이동"),
          //   onPressed: () {
          //     _movePage();
          //   },
          // ),
          // TextButton(
          //   child: Text("연결취소"),
          //   onPressed: ()  {
          //      _subscription!.cancel();
          //     Navigator.pop(context);
          //   },
          // ),
          // ],
        );
      },
    );
  }

  void _movePage() {
    Future.delayed(const Duration(milliseconds: 2000), () {
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



      if (decode.substring(0, 1) == 'P') {
        String result = decode.replaceAll(RegExp('\\D'), ""); // 정규식 숫자만
        print('배터리 잔량 : $result');

        Battery.power = result;
      } else if (decode.substring(0, 1) == 'L') {
        String result = decode.replaceAll(RegExp('\\D'), "");

        // 악력 없으면 로그 x - 테스트시 로그 지저분해서
        if (decode.substring(0, 1) == 'L' && 16267000 < int.parse(result)) {
          return null;
        }

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
      } else if (decode.substring(0, 1) == 'C1') {
        print('구성 리스트 outCallback1 가져오기 성공');
        print(decode);

        print(decode.substring(3, 14));

        String str = decode.substring(3, 14);

        List<String> result = str.split(',');

        print(result);

        await prefs.setStringList('items', result);
        outCallback1 = prefs.getStringList('items')!;
      } else if (decode.substring(0, 1) == 'C2') {
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
      } else if (decode.substring(0, 1) == 'D') {
        // 2D 모드
        String str = decode.substring(2, 11);
        gyro = str.split(',');

        var deltaX = 0;
        var deltaY = 0;
        var state = 1;

        var x = int.parse(gyro[0]);
        var y = int.parse(gyro[1]);

        if (deltaX.abs() < 5 && x.abs() > 5 ||
            deltaY.abs() < 5 && y.abs() > 5) {
          state = 0;
        }
        if (deltaX.abs() > 5 && x.abs() < 5 ||
            deltaY.abs() > 5 && y.abs() < 5) {
          state = 2;
        }

        deltaX = x;
        deltaY = y;

        Gyro.x = x.toDouble();
        Gyro.y = y.toDouble();

        print('2D 모드 : x : ${Gyro.x} / y : ${Gyro.y}');

          Gyro.dataXY = [x.toDouble(), y.toDouble()];
      } else if (decode.substring(0, 2) == 'A[') {
        String str = decode.substring(2, 16);
        List list = str.split(',');

        int x = twoCompleteToDecimal(list[0]);
        int y = twoCompleteToDecimal(list[1]);
        int z = twoCompleteToDecimal(list[2]);

        // print(' A 일때 $list');
        // print(' A 일때 x : $x / y : $y / z : $z ');

        Gyro.acc_x = lsb_to_mps2(x, 2.0, 16);
        Gyro.acc_y = lsb_to_mps2(y, 2.0, 16);
        Gyro.acc_z = lsb_to_mps2(z, 2.0, 16);

        // print('acc_x : ${Gyro.acc_x} / acc_y : ${Gyro.acc_y} / acc_z ${Gyro.acc_z}');

        Gyro.accXYZ = [Gyro.acc_x, Gyro.acc_y, Gyro.acc_z];
      } else if (decode.substring(0, 2) == 'G[') {
        String str = decode.substring(2, 16);
        List list = str.split(',');

        int x = twoCompleteToDecimal(list[0]);
        int y = twoCompleteToDecimal(list[1]);
        int z = twoCompleteToDecimal(list[2]);

        // print(' G 일때 $list');
        // print(' G 일때 x : $x / y : $y / z : $z ');

        Gyro.acc_x = lsb_to_mps2(x, 125.0, 16);
        Gyro.acc_y = lsb_to_mps2(y, 125.0, 16);
        Gyro.acc_z = lsb_to_mps2(z, 125.0, 16);

        print('3D 모드 : acc_x : ${Gyro.acc_x} / acc_y : ${Gyro.acc_y} / acc_z ${Gyro.acc_z}');

        Gyro.accXYZ = [Gyro.acc_x, Gyro.acc_y, Gyro.acc_z];
      } else {
        print('decoding : $decode');
      }
    }, onError: (dynamic error) {});
  }

  int twoCompleteToDecimal(String hexStr) {
    int decimal = int.parse(hexStr, radix: 16);
    if ((decimal & 0x8000) == 0) {
      return decimal;
    } else {
      return ((~decimal + 0x01).toSigned(16) * -1);
    }
  }

  double lsb_to_mps2(int loc, double g_range, int bit_width) {
    double half_scale = (1 << bit_width) / 2.0;
    return (Gyro.GRAVITY_EARTH * loc.toDouble() * g_range) / half_scale;
  }

  double lsb_to_dps(int loc, double dps, int bit_width) {
    double half_scale = (1 << bit_width).toDouble() / 2.0;
    return (dps / half_scale + Gyro.BMI2_GYR_RANGE_2000.toDouble()) *
        loc.toDouble();
  }
}
