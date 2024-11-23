import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/geradorQRCodeController.dart';

class GeradorQRCodeScreen extends StatefulWidget {
  const GeradorQRCodeScreen({super.key});

  @override
  _GeradorQRCodeScreenState createState() => _GeradorQRCodeScreenState();
}

class _GeradorQRCodeScreenState extends State<GeradorQRCodeScreen> {
  final geradorController = geradorQRCodeController();

  @override
  void dispose() {
    geradorController.dispose();
    super.dispose();
  }

  void _gerarQRCode() {
    setState(() {
      geradorController.gerarQRCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: geradorController.nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: geradorController.cpfController,
              decoration: const InputDecoration(labelText: 'CPF'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _gerarQRCode,
              child: const Text('Gerar QR Code'),
            ),
            const SizedBox(height: 20),
            if (geradorController.qrCodeData.isNotEmpty)
              QrImageView(
                data: geradorController.qrCodeData, // Dados do QR Code
                version: QrVersions.auto,
                size: 200.0,
              ),
          ],
        ),
      ),
    );
  }
}
