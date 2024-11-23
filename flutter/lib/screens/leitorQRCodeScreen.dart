import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  // Instanciando o controlador
  MobileScannerController cameraController = MobileScannerController();
  
  String? scannedCode; // Variável para armazenar o código escaneado

  @override
  void initState() {
    super.initState();
    // Solicitar permissão para usar a câmera
    _requestCameraPermission();
  }

  // Função para solicitar permissão de câmera
  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      // Solicita permissão se ainda não foi concedida
      await Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner QR Code'),
      ),
      body: Stack(
        children: [
          // Widget MobileScanner
          MobileScanner(
            controller: cameraController,
            onDetect: (barcodeCapture) {
              if (barcodeCapture.barcodes.isNotEmpty) {
                final String code = barcodeCapture.barcodes.first.rawValue ?? 'Desconhecido';
                setState(() {
                  scannedCode = code; // Atualiza o estado com o código escaneado
                });
                // Você pode adicionar lógica aqui para processar o código escaneado
              }
            },
          ),
          Positioned(
            top: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                // Alternar o flash (se disponível)
                cameraController.toggleTorch();
              },
              child: Text('Flash'),
            ),
          ),
          // Exibe o código escaneado na tela
          if (scannedCode != null)
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.black.withOpacity(0.6),
                child: Text(
                  'Código detectado : $scannedCode',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
