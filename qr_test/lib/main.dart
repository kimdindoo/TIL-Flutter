import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

List<String> items = <String>['1', '2', '3'];

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  String dropdownValue = items.first;
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ListView(
            children: [
              QrImageView(
                data: 'rootlink',
                version: QrVersions.auto,
                size: 200.0,
                gapless: false,
                // embeddedImage: AssetImage('asset/img/rootlink logo.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(150, 150),
                ),
              ),
              Text('rootlink'),
              SizedBox(height: 200),
              QrImageView(
                data: '김진수',
                version: QrVersions.auto,
                size: 200.0,
                gapless: false,
                // embeddedImage: AssetImage('asset/img/rootlink logo.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(150, 150),
                ),
              ),
              Text('김진수'),
              SizedBox(height: 200),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: 'software',
                ),
              ),
              SizedBox(height: 200),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: BarcodeWidget(
                  barcode: Barcode.ean13(),
                  data: '873487659295',
                ),
              ),
              SizedBox(height: 200),
              InteractiveViewer(child: Image.asset('asset/img/barcode.png')),
              DropdownButtonExample(),
              SizedBox(height: 400),

              // 이미지 넣기
            ],
          ),
        ),
      ),
    );
  }
}

const List<String> list = <String>['ean13', 'ean8', 'code128'];

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('Barcode: '),
              DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ],
          ),
          Row(
            children: [
              Text('Data: '),
              Container(
                width: 150,
                child: TextField(
                  controller: _textEditingController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     String zeros = '0' * 7;
          //     print(zeros);
          //   },
          //   child: Text('생성'),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: BarcodeWidget(
                barcode: getBarcode(),
                data: text(dropdownValue),
                errorBuilder: (context, error) => Center(child: Text(error))),
          ),
        ],
      ),
    );
  }

  Barcode getBarcode() {
    switch (dropdownValue) {
      case 'ean13':
        return Barcode.ean13();
      case 'ean8':
        return Barcode.ean8();
      case 'code128':
        return Barcode.code128();
      default:
        return Barcode.code128();
    }
  }

  String text(String value) {
    switch (value) {
      case 'ean13':
        String inputText = _textEditingController.text;
        int length = _textEditingController.text.length;
        if (length >= 12) {
          return inputText.substring(0, 12);
        }
        String zeros = '0' * (12 - length);
        return _textEditingController.text + zeros;
      case 'ean8':
        String inputText = _textEditingController.text;
        int length = _textEditingController.text.length;
        if (length >= 7) {
          return inputText.substring(0, 7);
        }
        String zeros = '0' * (7 - length);
        return _textEditingController.text + zeros;
      case 'code128':
        int length = _textEditingController.text.length;
        if(length < 1) return 'rootlink';
        return _textEditingController.text;
      default:
        return _textEditingController.text;
    }
  }
}
