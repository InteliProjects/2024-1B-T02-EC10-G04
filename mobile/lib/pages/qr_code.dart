import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:mobile/pages/new_orders_page.dart';
import 'package:mobile/models/qrcode.dart';
import 'package:mobile/services/pyxis.dart';
import 'package:mobile/models/pyxis.dart';
import 'package:mobile/controller/pyxis.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isScanning = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed('/orders');
          },
        ),
        title: const Text(
          'Leitor de QR Code',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Scan the QR Code',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!_isScanning) {
        setState(() {
          _isScanning = true;
        });
        controller.pauseCamera();

        try {
          PyxisService pyxisService = PyxisService();
          PyxisController pyxisController = PyxisController(pyxisService: pyxisService);
          Pyxis? pyxis = await pyxisController.getPyxisById(context, scanData.code!);

          if (pyxis == null) {
            controller.resumeCamera();
            setState(() {
              _isScanning = false;
            });
            return;
          }

          Navigator.pushNamed(
            // ignore: use_build_context_synchronously
            context,
            NewOrderPage.routeName,
            arguments: QRCodeArguments(
              scanData.code!,
              pyxis.label!,
            ),
          ).then((_) {
            controller.resumeCamera();
            setState(() {
              _isScanning = false;
            });
          });
        } catch (e) {
          print(e);
          controller.resumeCamera();
          setState(() {
            _isScanning = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}