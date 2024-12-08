import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (barcodeCapture) {
              if (barcodeCapture.barcodes.isNotEmpty) {
                final String qrCode =
                    barcodeCapture.barcodes.first.rawValue ?? 'Desconhecido';

                // Parar a câmera antes de navegar
                cameraController.stop();

                // Navegar para a página "Máquinas" com o QR Code como argumento
                Navigator.pushNamed(context, '/maquinas', arguments: qrCode);
              }
            },
          ),
          Positioned(
            top: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                cameraController.toggleTorch();
              },
              child: const Text('Flash'),
            ),
          ),
        ],
      ),
    );
  }
}
