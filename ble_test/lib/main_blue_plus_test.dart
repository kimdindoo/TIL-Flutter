import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// StreamSubscription? _subscription;

final String SERVICE_UUID = '00001F00-8835-40B6-8651-5691F8630806';
final String CHARACTERISTIC_UUID_RX = '00001F11-8835-40B6-8651-5691F8630806';
final String CHARACTERISTIC_UUID_TX = '00001F10-8835-40B6-8651-5691F8630806';
final String TARGET_DEVICE_NAME = 'moozi_023';

late List<ScanResult> scanResult; // Bluetooth Device Scan List
late BluetoothDevice targetDevice;
late BluetoothCharacteristic targetCharacteristicRx;
late BluetoothCharacteristic targetCharacteristicTx;
late String receivedValue;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home: BluePlusScreen(),
    ),
  );
}

class BluePlusScreen extends StatefulWidget {
  BluePlusScreen({Key? key}) : super(key: key);

  @override
  State<BluePlusScreen> createState() => _BluePlusScreenState();
}

class _BluePlusScreenState extends State<BluePlusScreen> {
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
            child: Text('블루투스 전체 검색 + 연결'),
          ),
          ElevatedButton(
            onPressed: () {
              flutterBlue.stopScan();
            },
            child: Text('블루투스 검색 중지'),
          ),
          ElevatedButton(
            onPressed: () {
              discover(targetDevice);
            },
            child: Text('블루투스 읽기'),
          ),
          ElevatedButton(
            onPressed: () {
              sendMessage();
            },
            child: Text('블루투스 쓰기'),
          ),
        ],
      ),
    );
  }

  void scan() {
    flutterBlue.startScan(timeout: Duration(seconds: 3));

    flutterBlue.scanResults
        .listen((results) {}, onError: (e) => print(e))
        .onData((data) {
      print(data.length);
      scanResult = data;
    });
    // Stop scanning
    flutterBlue.stopScan();
    Future.delayed(const Duration(seconds: 5), () {
      scanDevice();
    });
  }

  Future<void> scanDevice() async {
    for (ScanResult r in scanResult) {
      if (r.device.name == TARGET_DEVICE_NAME) {
        print("Target : ${r.device.name} Found!");
        targetDevice = r.device;
        await connectToDevice(targetDevice);
      }
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    if (device == null) return;

    await device.connect();
  }


  Future<void> discover(BluetoothDevice device) async {
    //   List<BluetoothService> services = await device.discoverServices();
    //   services.forEach((service) async {
    //
    //     var characteristics = service.characteristics;
    //
    //     for (BluetoothCharacteristic c in characteristics) {
    //       List<int> value = await c.read();
    //       print(value);
    //     }
    //   });
    // }

    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      service.characteristics.forEach((characteristic) {
        // print(characteristic.uuid);
        // I/flutter (28655): 00002a00-0000-1000-8000-00805f9b34fb
        // I/flutter (28655): 00002a01-0000-1000-8000-00805f9b34fb
        // I/flutter (28655): 00002a04-0000-1000-8000-00805f9b34fb
        // I/flutter (28655): 00002aa6-0000-1000-8000-00805f9b34fb
        // I/flutter (28655): 00002ac9-0000-1000-8000-00805f9b34fb
        // I/flutter (28655): 00002a05-0000-1000-8000-00805f9b34fb
        // I/flutter (28655): 00001f10-8835-40b6-8651-5691f8630806
        // I/flutter (28655): 00001f11-8835-40b6-8651-5691f8630806

        if (service.uuid == new Guid(SERVICE_UUID)){
          service.characteristics.forEach((characteristic) {
            print(characteristic.uuid);
            if(characteristic.uuid == new Guid(CHARACTERISTIC_UUID_RX)) {
              targetCharacteristicRx = characteristic;
              // print('targetCharacteristicRx : $targetCharacteristicRx');
            }
            else if (characteristic.uuid == new Guid(CHARACTERISTIC_UUID_TX)) {
              targetCharacteristicTx = characteristic;
              // print('targetCharacteristicTx : $targetCharacteristicTx');

              // characteristic.setNotifyValue(true);
              // characteristic.value.listen((value) {
              //   if (value.length > 0) {
              //     receivedValue = value[0].toString();
              //     print("**[$receivedValue]**");
              //   }
              //   setState(() {});
              // });

            }
          });
        }

        // characteristic.setNotifyValue(true);
        // characteristic.value.listen((value) {
        //   if (value.length > 0) {
        //     receivedValue = value[0].toString();
        //     print("**[$receivedValue]**");
        //   }
        //   setState(() {});
        // });


      });
    });
  }

  // Future<void> write(BluetoothDevice device) async {
  //   List<BluetoothService> services = await device.discoverServices();
  //   services.forEach((service) async {
  //
  //     var descriptors = service.charact
  //
  //     for (BluetoothDescriptor d in descriptors) {
  //       List<int> value = await d.read();
  //       print(value);
  //     }
  //     await d.write([0x12, 0x34]);
  //   });
  // }

  void sendMessage() {
    writeData('vibrator');
  }

  writeData(String data) async {
    // if (targetCharacteristicRx == null) return;

    List<int> bytes = utf8.encode(data);
    await targetCharacteristicRx.write(bytes);
  }
}
