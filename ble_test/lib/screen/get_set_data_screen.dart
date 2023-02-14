import 'dart:convert';

import 'package:ble_test/common/data.dart';
import 'package:ble_test/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class GetSetDataScreen extends StatefulWidget {
  final List<String> outCallback1;
  final List<String> outCallback2;

  const GetSetDataScreen(
      {required this.outCallback1, required this.outCallback2, Key? key})
      : super(key: key);

  @override
  State<GetSetDataScreen> createState() => _GetDataScreenState();
}

class SliderController {
  double sliderValue;

  SliderController(this.sliderValue);
}

class _GetDataScreenState extends State<GetSetDataScreen> {
  List<String> _texts = ['VM', 'VA', 'VB', 'VC', 'VD'];

  late List<bool> _isChecked;

  String sendVibrationOption = 'VA';

  late SliderController _powerSliderController;
  late SliderController _operationSliderController;
  late SliderController _intervalSliderController;

  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();

    int vibrationMode = int.parse(widget.outCallback2[2]); // 0, 1, 2, 3, 4

    double grabPowerLow = double.parse(widget.outCallback1[0]);
    double grabPowerHigh = double.parse(widget.outCallback1[1]);

    double vibrationPower = double.parse(widget.outCallback1[2]);
    double vibrationOperation = double.parse(widget.outCallback2[0]);
    double vibrationInterval = double.parse(widget.outCallback2[1]);

    _isChecked = List<bool>.generate(
        _texts.length, (index) => index == vibrationMode ? true : false);

    _powerSliderController = SliderController(vibrationPower);
    _operationSliderController = SliderController(vibrationOperation);
    _intervalSliderController = SliderController(vibrationInterval);
    _currentRangeValues = RangeValues(grabPowerLow, grabPowerHigh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('블루투스 설정'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey),
                  onPressed: () {
                    print(Battery.power);
                    getPower();
                    setState(() {});
                  },
                  child: Text('배터리 잔량 : ${Battery.power}'),
                ),
                ElevatedButton(
                  onPressed: () {
                    LedOn();
                  },
                  child: Text('LED ON'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ledOff();
                  },
                  child: Text('LED OFF'),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              onPressed: () {},
              child: Text('진동 종류 설정'),
            ),
            _checkBoxVibration(),
            buildSlider(
              controller: _powerSliderController,
              divisions: 100,
              color: Colors.blueGrey,
              max: 100,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              onPressed: () {
                print(_powerSliderController.sliderValue);
                setVibrationPower(_powerSliderController.sliderValue.toInt());
              },
              child: Text('진동 세기 설정(0~100)'),
            ),
            buildSlider(
              controller: _operationSliderController,
              divisions: 570,
              color: Colors.blueGrey,
              max: 570,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              onPressed: () {
                print(_operationSliderController.sliderValue);
                setVibrationTime(
                    _operationSliderController.sliderValue.toInt());
              },
              child: Text('진동 동작 시간 설정(0~570)'),
            ),
            buildSlider(
              controller: _intervalSliderController,
              divisions: 570,
              color: Colors.blueGrey,
              max: 570,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              onPressed: () {
                print(_intervalSliderController.sliderValue);
                setVibrationInterval(
                    _intervalSliderController.sliderValue.toInt());
              },
              child: Text('진동 정지 시간 설정(0~570)'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey),
                  onPressed: () {
                    startVibration();
                  },
                  child: Text('진동 테스트'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  onPressed: () {
                    setWalkModeOn();
                  },
                  child: Text('만보기 모드 ON'),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  onPressed: () {
                    setWalkModeOff();
                  },
                  child: Text('만보기 모드 OFF'),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () async {
                print('1');
                print(OnWalk.count);
                getWalkCount();
                print('2');
                print(OnWalk.count);
                setState(() {});
              },
              child: Text('만보기 카운트 : ${OnWalk.count}'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () {
                resetWalkCount();
                setState(() {
                  OnWalk.count = 0;
                });
              },
              child: Text('만보기 리셋'),
            ),
            RangeSlider(
              values: _currentRangeValues,
              max: 100,
              divisions: 10,
              activeColor: Colors.redAccent,
              // inactiveColor: Colors.grey,
              labels: RangeLabels(
                _currentRangeValues.start.round().toString(),
                _currentRangeValues.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRangeValues = values;
                });
              },
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                setGrabPower(_currentRangeValues.start.toInt(),
                    _currentRangeValues.end.toInt());

                Grab.loadCellLowValue = _currentRangeValues.start.toInt();
                Grab.loadCellHighValue = _currentRangeValues.end.toInt();
              },
              child: Text('악력 값 설정'),
            ),
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
              },
              child: Text('자이로 모드 끄기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkBoxVibration() {
    return Column(
      children: [
        SizedBox(
          height: 310,
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
              setVibrationType(sendVibrationOption);
            },
          ),
        )
      ],
    );
  }

  Widget buildSlider({
    SliderController? controller,
    int? divisions,
    Color? color,
    double enabledThumbRadius = 10.0,
    double elevation = 1.0,
    double max = 100.0,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 10),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              thumbColor: color,
              activeTickMarkColor: color,
              valueIndicatorColor: color,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: enabledThumbRadius,
                elevation: elevation,
              ),
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            ),
            child: Slider(
              value: controller!.sliderValue,
              min: 0.0,
              max: max,
              divisions: divisions,
              label: '${controller.sliderValue.round()}',
              onChanged: (double newValue) {
                setState(
                  () {
                    controller.sliderValue = newValue;
                    print(controller.sliderValue);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
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

  void LedOn() async {
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

  void ledOff() async {
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

  void setVibrationPower(int value) async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('VS$value'); // 0 ~ 100
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }

  void setVibrationTime(int value) async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('VO$value'); // 0 ~ 570
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }

  void setVibrationInterval(int value) async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('VI$value'); // 0 ~ 570
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }

  void startVibration() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('VZ');
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }

  void setVibrationType(String value) async {
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

  void getVersion() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('CV');
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }

  void setWalkModeOn() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('SN');
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }

  void setWalkModeOff() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('SF');
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }

  Future getWalkCount() async {
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

  void resetWalkCount() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('SS');
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }

  void setGrabPower(int min, int max) async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes1 = ascii.encode('LL$min');
    List<int> bytes2 = ascii.encode('LH$max');

    print('encoding : $bytes1');
    print('encoding : $bytes2');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes1);

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes2);
  }

  void getLoadCellInit() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('LI');
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }

  void getLoadCellMiddle() async {
    String? foundDeviceId = await storage.read(key: DEVICE_ID);

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse('00001F00-8835-40B6-8651-5691F8630806'),
      characteristicId: Uuid.parse('00001F11-8835-40B6-8651-5691F8630806'),
      deviceId: foundDeviceId!,
    );

    List<int> bytes = ascii.encode('LM');
    print('encoding : $bytes');

    flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic,
        value: bytes);
  }
}
