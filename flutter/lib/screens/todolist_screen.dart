// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_somativa/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class TodolistScreen extends StatefulWidget {
  final User user;
  const TodolistScreen({super.key, required this.user});

  @override
  State<TodolistScreen> createState() => _TodolistScreenState();
}

class _TodolistScreenState extends State<TodolistScreen> {
  final AuthService _service = AuthService();

  final String _scannedData = "Nenhum QR Code escaneado"; // Dados escaneados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRStock'),
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
      body: Center( // Centraliza o conteúdo
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
                      onScan: (data)async {
                        if (await canLaunch(data)) {
                          await launch(data);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Não foi possível abrir: $data')),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.qr_code, size: 36), // Ícone maior
              label: const Text(
                'Escanear QR Code'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
              ),
             
            ),
            const SizedBox(height: 20),
            Text(
              _scannedData,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center
            ),
          ],
        ),
      ),
    );
  }
}

// Tela de Scanner
class QRScannerScreen extends StatelessWidget {
  final Function(String) onScan;

  const QRScannerScreen({Key? key, required this.onScan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneie um QR Code'),
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
