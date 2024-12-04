import 'package:cloud_firestore/cloud_firestore.dart';

class Requisicao {
  //atributos
  final String id;
  String machineId;
  String nameMachine;
  final String userId;
  String nomePeca;
  String qtdPeca;
  String description;
  final DateTime timestamp;

  Requisicao({
    required this.id,
    required this.userId,
    required this.machineId,
    required this.nameMachine,
    required this.nomePeca,
    required this.qtdPeca,
    required this.description,
    required this.timestamp,
  });

  // toMap
Map<String, dynamic> toMap() {
  return {
    'nameMachine': nameMachine.isNotEmpty ? nameMachine : 'Máquina Desconhecida',
    'machineId': machineId.isNotEmpty ? machineId : 'ID Desconhecido',
    'userid': userId,
    'nomePeca': nomePeca.isNotEmpty ? nomePeca : 'Peça Desconhecida',
    'qtdPeca': qtdPeca.isNotEmpty ? qtdPeca : '0',
    'description': description.isNotEmpty ? description : 'Sem descrição',
    'timestamp': timestamp,
  };
}


  // fromMap
factory Requisicao.fromMap(Map<String, dynamic> map, String doc) {
  try {
    return Requisicao(
      id: doc,
      nameMachine: map['nameMachine'] ?? 'Máquina Desconhecida', // Valor padrão
      userId: map['userid'] ?? '',
      machineId: map['machineId'] ?? '',
      nomePeca: map['nomePeca'] ?? '',
      qtdPeca: map['qtdPeca'] ?? '0',
      description: map['description'] ?? 'Sem descrição',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  } catch (e) {
    throw Exception('Erro ao mapear os dados para Requisicao: $e');
  }
}

}