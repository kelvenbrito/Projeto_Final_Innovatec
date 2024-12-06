import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class QRScannerScreen extends StatefulWidget {
  final Function(String) onScan;

  const QRScannerScreen({super.key, required this.onScan});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class ScannerState extends ChangeNotifier {
  bool isProcessing = false;

  void setIsProcessing(bool value) {
    isProcessing = value;
    notifyListeners();
  }
}

class _QRScannerScreenState extends State<QRScannerScreen> with WidgetsBindingObserver {
  final _scannerState = ScannerState();
  late MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    // Adicionando o observer de ciclo de vida
    WidgetsBinding.instance.addObserver(this);
    
    _controller = MobileScannerController(
      formats: [BarcodeFormat.qrCode],
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // Removendo o observer de ciclo de vida
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneie um QR Code'),
        backgroundColor: Colors.black,
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final qrData = barcodes.first.rawValue!;
            print("QR Data detectado: $qrData");

            // Navegar para a próxima tela
            Navigator.of(context).pop(); // Fecha o scanner
            Navigator.pushNamed(context, '/maquinas', arguments: qrData);
          }
        },
      ),
    );
  }
}
