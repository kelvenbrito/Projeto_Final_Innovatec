import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/requisicao.dart';

class RequisicaoController{
  //atributo list
  List<Requisicao> _list = [];
  List<Requisicao> get list => _list;

  //conectar ao firebase FireStore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //métodos
  //add
  Future<void> add(Requisicao requisicao) async{
    await _firestore.collection('requisicao').add(requisicao.toMap());
  }
  //deletar
  Future<void> delete(String id) async{
    if (kDebugMode) {
      print(id);
    }
    await _firestore.collection('requisicao').doc(id).delete();
    if (kDebugMode) {
      print("ok");
    }
  }
  //fetch list
Future<List<Requisicao>> fetchList(String userId) async {
  try {
    // Busca documentos no Firestore
    final QuerySnapshot result = await _firestore
        .collection('requisicao')
        .where('userid', isEqualTo: userId)
        .get();

    // Log para verificar a quantidade de documentos retornados
    if (kDebugMode) {
      print('Total de documentos encontrados: ${result.docs.length}');
    }

    // Converte os documentos em objetos do tipo Requisicao
    _list = result.docs.map((doc) {
      return Requisicao.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    // Log do tamanho da lista convertida
    if (kDebugMode) {
      print('Total de itens na lista: ${_list.length}');
    }

    return _list;
  } catch (e) {
    // Log de erro
    if (kDebugMode) {
      print('Erro ao buscar lista de requisições: $e');
    }
    throw Exception('Erro ao buscar lista de requisições');
  }
}

//editar
Future<void> update(Requisicao task) async {
  try {
    await _firestore.collection('requisicao').doc(task.id).update({
      'machineId': task.machineId,
      'nameMachine': task.nameMachine,
      'nomePeca': task.nomePeca,
      'qtdPeca': task.qtdPeca,
      'description': task.description,
    });
  } catch (e) {
    // Trate qualquer erro que possa ocorrer durante a atualização
    if (kDebugMode) {
      print("Erro ao atualizar requisicao: $e");
    }
    throw Exception("Erro ao atualizar requisicao");
  }
}

  
}

  


