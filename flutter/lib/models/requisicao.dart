import 'package:cloud_firestore/cloud_firestore.dart';

class Requisicao {
  //atributos
  final String id;
  String description;
  final String userId;
  final String machineId;
  final String nameMachine;
  final DateTime timestamp;

  Requisicao(
      {required this.id,
      required this.description,
      required this.userId,
      required this.machineId,
      required this.nameMachine,
      required this.timestamp});

  // toMap
  Map<String, dynamic> toMap() {
    return {'nameMachine': nameMachine, 'machineId': machineId, 'userid': userId, 'description': description,  'timestamp': timestamp};
  }

  // fromMap
  factory Requisicao.fromMap(Map<String, dynamic> map, String doc) {
    return Requisicao(
      id: doc,
      nameMachine: map['nameMachine'],
      userId: map['userid'],
      machineId: map['machineId'],
      description: map['description'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
