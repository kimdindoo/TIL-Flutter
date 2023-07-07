import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(
      MaterialApp(
        // theme: ThemeData(
        //   elevatedButtonTheme: ElevatedButtonThemeData(
        //     style: ButtonStyle(
        //       backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
        //       foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
        //     ),
        //   ),
        // ),
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        home: MyHome(),
      ),
    );

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const QRViewExample(),
            ));
          },
          child: const Text('qrView'),
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool camerOn =  true;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  children: [
                    Text('QR스캔'),
                    Row(
                      children: [
                        FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return IconButton(
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {});
                              },
                              icon: snapshot.data == false
                                  ? Icon(
                                      Icons.flash_on,
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.flash_off,
                                      size: 20,
                                    ),
                            );
                          },
                        ),
                        // Spacer(),
                        SizedBox(width: MediaQuery.of(context).size.width / 3),
                        FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return IconButton(
                              onPressed: () async {
                                await controller?.flipCamera();
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.flip_camera_ios,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(flex: 4, child: _buildQrView(context)),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (result != null)
                      Text(
                          'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                    else
                      const Text('Scan a code'),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: <Widget>[
                    //     Container(
                    //       margin: const EdgeInsets.all(8),
                    //       child: ElevatedButton(
                    //           onPressed: () async {
                    //             await controller?.toggleFlash();
                    //             setState(() {});
                    //           },
                    //           child: FutureBuilder(
                    //             future: controller?.getFlashStatus(),
                    //             builder: (context, snapshot) {
                    //               return Text('Flash: ${snapshot.data}');
                    //             },
                    //           )),
                    //     ),
                    //     Container(
                    //       margin: const EdgeInsets.all(8),
                    //       child: ElevatedButton(
                    //           onPressed: () async {
                    //             await controller?.flipCamera();
                    //             setState(() {});
                    //           },
                    //           child: FutureBuilder(
                    //             future: controller?.getCameraInfo(),
                    //             builder: (context, snapshot) {
                    //               if (snapshot.data != null) {
                    //                 return Text(
                    //                     'Camera facing ${describeEnum(snapshot.data!)}');
                    //               } else {
                    //                 return const Text('loading');
                    //               }
                    //             },
                    //           )),
                    //     )
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: IconButton(
                            onPressed: () async {
                              camerOn ? await controller?.pauseCamera() : await controller?.resumeCamera();
                              setState(() {
                                camerOn = !camerOn;
                              });
                            },
                            icon: camerOn ? Icon(
                              Icons.pause,
                              size: 20,
                            ) : Icon(
                              Icons.play_arrow_rounded,
                              size: 20,
                            )
                          ),
                        ),
                        // Container(
                        //   margin: const EdgeInsets.all(8),
                        //   child: IconButton(
                        //     onPressed: () async {
                        //       await controller?.resumeCamera();
                        //       setState(() {});
                        //     },
                        //     icon: Icon(
                        //       Icons.play_arrow_rounded,
                        //       size: 20,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
