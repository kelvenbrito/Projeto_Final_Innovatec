import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  // Instanciando o controlador da câmera
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
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
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
                // Lógica adicional pode ser adicionada aqui para processar o código escaneado
              }
            },
          ),
          
          // Botão de flash
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(
                cameraController.isTorchOn ? Icons.flash_off : Icons.flash_on,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                // Alternar o flash (se disponível)
                cameraController.toggleTorch();
              },
            ),
          ),
          
          // Exibe o código escaneado na tela, caso exista
          if (scannedCode != null)
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Código detectado: $scannedCode',
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

extension on MobileScannerController {
  get isTorchOn => null;
}
