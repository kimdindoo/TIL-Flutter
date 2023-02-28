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
      // 5초 동안 블루투스 기기 검색
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
              // 다음페이지 이동 팝업
              _showSuccessDialog();
              _movePage();
            } else if (connectionState.connectionState ==
                DeviceConnectionState.disconnected) {
              _showFailDialog();
            }
          }, onError: (Object error) {});
        },
        child: Text('연결'),
      ),
    );
  }

  void _showFailDialog() {
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("연결 성공"),
          content: Text("설정하면으로 이동합니다."),
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
      print(decode);

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

        Grab.percentage = (res * 100.0 * 100).round() / 100.0;
        Grab.kg = (Grab.percentage / 2.0 * 100).round() / 100.0;
        Grab.lb = (Grab.kg * 2.2046 * 100).round() / 100.0;

        Grab.grabPower = [Grab.percentage, Grab.kg, Grab.lb];

        print('악력 크기 : ${Grab.percentage} % ${Grab.kg} kg ${Grab.lb} lb');
      } else if (decode.substring(0, 2) == 'C1') {
        print('구성 리스트 outCallback1 가져오기 성공');
        String str = decode.substring(3, 14);
        List<String> result = str.split(',');
        print(result);

        await prefs.setStringList('items', result);
        outCallback1 = prefs.getStringList('items')!;
      } else if (decode.substring(0, 2) == 'C2') {
        print('구성 리스트 outCallback2 가져오기 성공');
        String str = decode.substring(3, 14);
        List<String> result = str.split(',');
        print(result);

        await prefs.setStringList('items2', result);
        outCallback2 = prefs.getStringList('items2')!;
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

        print('2D 모드 : x : ${Gyro.x} / y : ${Gyro.y}');

        Gyro.dataXY = [x, y];

        // onDeltaXY(x, y, state);

      } else if (decode.substring(0, 2) == 'A[') {
        // 3D 모드
        processAcc(decode);
      } else if (decode.substring(0, 2) == 'G[') {
        // 3D 모드
        processGyro(decode);
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

  //2D
  // void onDeltaXY(int x, int y, int state) {
  //
  //   print('state : $state');
  //
  //   // if (state == 0) {
  //   //   Gyro.sumdx = 0;
  //   //   Gyro.sumdy = 0;
  //   // } else if (state == 2) {
  //   //
  //   // } else {
  //   //   Gyro.sumdx += x;
  //   //   Gyro.sumdy += y;
  //   // }
  //
  //   Gyro.sumdx += x;
  //   Gyro.sumdy += y;
  //
  //   print("x: $x y: $y");
  //   print("sumdx: ${Gyro.sumdx} sumdy: ${Gyro.sumdy}");
  //
  // }

  //3D A[] 데이터 수신할때
  void processAcc(String decode) {
    // String str = decode.substring(2, 16);
    List list = decode.split(',');

    int x = 0;
    int y = 0;
    int z = 0;
    String d = '';

    if (list.length == 3) {
      x = twoCompleteToDecimal(list[0].substring(2));
      y = twoCompleteToDecimal(list[1]);
      z = twoCompleteToDecimal(list[2].substring(0, 4));
      d = '0';

      print('x : ' + list[0].substring(2));
      print('y : ' + list[1]);
      print('z : ' + list[2].substring(0, 4));
    } else {
      x = twoCompleteToDecimal(list[0]);
      y = twoCompleteToDecimal(list[1]);
      z = twoCompleteToDecimal(list[2]);
      d = list[3].substring(0, 1);

      // 이 else문 안온다...
      print("!!!!!!!!!!!!! list.length > 3 !!!!!!!!!!!!!!");
      print(d);
    }

    double acc_x = lsb_to_mps2(x, 2.0, 16);
    double acc_y = lsb_to_mps2(y, 2.0, 16);
    double acc_z = lsb_to_mps2(z, 2.0, 16);

    onAccelerometer(acc_x, acc_y, acc_z, d);
  }

  void onAccelerometer(double x, double y, double z, String state) {
    x = (x * 1000).round() / 1000;
    y = (y * 1000).round() / 1000;
    z = (z * 1000).round() / 1000;

    if (state == '0') {
      x = x - 10.0;
      print("!!!!!!!!!!!!! 여기만 온다 !!!!!!!!!!!!!!");
    } else if (state == '1') {
      x = x + 10.0;
      print("!!!!!!!!!!!!! 여기 안온다 !!!!!!!!!!!!!!");
    } else if (state == '2') {
      y = y - 10.0;
      print("!!!!!!!!!!!!! 여기 안온다 !!!!!!!!!!!!!!");
    } else if (state == '3') {
      y = y + 10.0;
      print("!!!!!!!!!!!!! 여기 안온다 !!!!!!!!!!!!!!");
    } else if (state == '4') {
      z = z - 10.0;
      print("!!!!!!!!!!!!! 여기 안온다 !!!!!!!!!!!!!!");
    } else if (state == '5') {
      z = z + 10.0;
      print("!!!!!!!!!!!!! 여기 안온다 !!!!!!!!!!!!!!");
    }

    Gyro.acc_x = x.toInt();
    Gyro.acc_y = y.toInt();
    Gyro.acc_z = z.toInt();

    Gyro.accXYZ = [Gyro.acc_x, Gyro.acc_y, Gyro.acc_z];

    print(
        '3D 모드 : acc_x : ${Gyro.acc_x} / acc_y : ${Gyro.acc_y} / acc_z ${Gyro.acc_z}');
  }

  //3D G[] 데이터 수신할때
  void processGyro(String decode) {
    String str = decode.substring(2, 16);
    List list = str.split(',');

    int x = twoCompleteToDecimal(list[0]);
    int y = twoCompleteToDecimal(list[1]);
    int z = twoCompleteToDecimal(list[2]);

    double acc_x = lsb_to_dps(x, 125.0, 16);
    double acc_y = lsb_to_dps(y, 125.0, 16);
    double acc_z = lsb_to_dps(z, 125.0, 16);

    onGyroscope(acc_x, acc_y, acc_z);
  }

  void onGyroscope(double x, double y, double z) {
    x = (x * 1000).round() / 1000;
    y = (y * 1000).round() / 1000;
    z = (z * 1000).round() / 1000;

    Gyro.acc_x = x.toInt();
    Gyro.acc_y = y.toInt();
    Gyro.acc_z = z.toInt();

    Gyro.accXYZ = [Gyro.acc_x, Gyro.acc_y, Gyro.acc_z];

    print(
        '3D 모드 : acc_x : ${Gyro.acc_x} / acc_y : ${Gyro.acc_y} / acc_z ${Gyro.acc_z}');
  }
}
