import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home: BluePlusScreen(),
    ),
  );
}

class BluePlusScreen extends StatelessWidget {
  BluePlusScreen({Key? key}) : super(key: key);

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              scan();
            },
            child: Text('블루투스 전체 검색'),
          ),
          ElevatedButton(
            onPressed: () {
              flutterBlue.stopScan();
            },
            child: Text('블루투스 검색 중지'),
          ),
          ElevatedButton(
            onPressed: () async {

            },
            child: Text('블루투스 연결'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('블루투스 읽기'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('블루투스 쓰기'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('블루투스 연결 상태 확인'),
          ),
        ],
      ),
    );
  }

  void scan() {
    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));

// Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');

        if (r.device.name == 'moozi_023') {
          r.device.connect();

          print('connect moozi_023');
        }
      }
    });
  }
}
