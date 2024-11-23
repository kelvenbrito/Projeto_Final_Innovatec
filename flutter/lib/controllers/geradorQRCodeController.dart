import 'package:flutter/material.dart';

class geradorQRCodeController {
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  String qrCodeData = '';

  void gerarQRCode() {
    final data = cpfController.text;
    qrCodeData = 'https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=$data';
  }

  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
  }
}
