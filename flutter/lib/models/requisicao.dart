import 'package:cloud_firestore/cloud_firestore.dart';

class Requisicao {
  final String id;
  String machineId;
  String nameMachine;
  final String userEmail;  // Alterado para userEmail
  String nomePeca;
  String qtdPeca;
  String description;
  String status;
  final DateTime timestamp;

  Requisicao({
    required this.id,
    required this.userEmail,  // Alterado para userEmail
    required this.machineId,
    required this.nameMachine,
    required this.nomePeca,
    required this.qtdPeca,
    required this.description,
    this.status = 'em aberto',
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'nameMachine': nameMachine.isNotEmpty ? nameMachine : 'Máquina Desconhecida',
      'machineId': machineId.isNotEmpty ? machineId : 'ID Desconhecido',
      'userEmail': userEmail,  // Alterado para userEmail
      'nomePeca': nomePeca.isNotEmpty ? nomePeca : 'Peça Desconhecida',
      'qtdPeca': qtdPeca.isNotEmpty ? qtdPeca : '0',
      'description': description.isNotEmpty ? description : 'Sem descrição',
      'status': status,
      'timestamp': timestamp,
    };
  }

  factory Requisicao.fromMap(Map<String, dynamic> map, String doc) {
    try {
      return Requisicao(
        id: doc,
        nameMachine: map['nameMachine'] ?? 'Máquina Desconhecida',
        userEmail: map['userEmail'] ?? '',  // Alterado para userEmail
        machineId: map['machineId'] ?? '',
        nomePeca: map['nomePeca'] ?? '',
        qtdPeca: map['qtdPeca'] ?? '0',
        description: map['description'] ?? 'Sem descrição',
        status: map['status'] ?? 'em aberto',
        timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    } catch (e) {
      throw Exception('Erro ao mapear os dados para Requisicao: $e');
    }
  }
}
