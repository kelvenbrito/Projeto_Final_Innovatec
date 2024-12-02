
import 'package:cloud_firestore/cloud_firestore.dart';

class Requisicao {
  //atributos
  final String id;
   String titulo;
  final String userId;
  final DateTime timestamp;

  Requisicao({required this.id, required this.titulo, required this.userId, required this.timestamp});

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'userid': userId,
      'timestamp': timestamp
    };
  }
  // fromMap
  factory Requisicao.fromMap(Map<String, dynamic> map, String doc) {
    return Requisicao(
      id: doc,
      titulo: map['titulo'],
      userId: map['userid'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  
}