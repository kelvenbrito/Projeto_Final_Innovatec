import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

class GeradorQRCodeScreen extends StatefulWidget {
  const GeradorQRCodeScreen({super.key});

  @override
  _GeradorQRCodeScreenState createState() => _GeradorQRCodeScreenState();
}

class _GeradorQRCodeScreenState extends State<GeradorQRCodeScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final GlobalKey _qrKey = GlobalKey();

  String qrData = ''; // Variável para armazenar os dados do QR Code

  @override
  void initState() {
    super.initState();
    _nomeController.addListener(_atualizarQRCode);
    _cpfController.addListener(_atualizarQRCode);
  }

  @override
  void dispose() {
    _nomeController.removeListener(_atualizarQRCode);
    _cpfController.removeListener(_atualizarQRCode);
    _nomeController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _atualizarQRCode() {
    setState(() {
      qrData = 'Nome: ${_nomeController.text}, CPF: ${_cpfController.text}';
    });
  }

  Future<void> _gerarQRCodeEEnviarEmail() async {
    try {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/qrcode.png';

      // Renderiza o QRCode como imagem
      RenderRepaintBoundary boundary = _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      File(path).writeAsBytesSync(byteData!.buffer.asUint8List());

      // Envia o e-mail com o QRCode como anexo
      final Email email = Email(
        body: 'Aqui está o seu QR Code gerado com os dados inseridos.',
        subject: 'QR Code Gerado',
        recipients: [_emailController.text],
        attachmentPaths: [path],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("E-mail enviado com sucesso!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro ao enviar e-mail: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerador de QR Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Digite seu nome'),
            ),
            TextField(
              controller: _cpfController,
              decoration: const InputDecoration(labelText: 'Digite seu CPF'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Digite o e-mail para envio'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            RepaintBoundary(
              key: _qrKey,
              child: QrImageView(
                data: qrData, // Usa a variável qrData para o QR Code
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _gerarQRCodeEEnviarEmail,
              child: const Text('Enviar QR Code por E-mail'),
            ),
          ],
        ),
      ),
    );
  }
}
