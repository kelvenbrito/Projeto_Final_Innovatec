import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_somativa/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class InternaScreen extends StatefulWidget {
  final User user;
  const InternaScreen({super.key, required this.user, required String userId});

  @override
  State<InternaScreen> createState() => _InternaScreenState();
}

class _InternaScreenState extends State<InternaScreen> {
  final AuthService _service = AuthService();
  final String _scannedData = "Nenhum QR Code escaneado"; // Dados escaneados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRStock'),
        backgroundColor: Colors.black, // Background preto para o header
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _service.logoutUsuario();
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
      body: Center(
        // Centraliza o conteúdo
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botão para abrir o scanner de QR Code
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScannerScreen(
                      onScan: (data) async {
                        if (await canLaunch(data)) {
                          await launch(data);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Não foi possível abrir: $data')),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.qr_code, size: 36), // Ícone maior
              label: const Text('Escanear QR Code'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey, // Cor do texto
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/requisicao');
              },
              label: const Text("Requisição"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/maquinas');
              },
              label: const Text("Maquinas"),
            ),

            const SizedBox(height: 20),
            Text(
              _scannedData,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.black,
        child: const Center(
          child: Text(
            'Footer Content',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// Tela de Scanner
class QRScannerScreen extends StatelessWidget {
  final Function(String) onScan;

  const QRScannerScreen({super.key, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneie um QR Code'),
        backgroundColor: Colors.black,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              onScan(barcode.rawValue!);
              Navigator.pop(context); // Volta para a tela anterior.
              break;
            }
          }
        },
      ),
    );
  }
}
