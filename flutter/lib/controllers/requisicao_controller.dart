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
  Future<List<Requisicao>> fetchList(String userId) async{
    final QuerySnapshot result = await _firestore.collection(
      'requisicao')
      .where(
        'userid',
         isEqualTo: userId)
         .get();
    if (kDebugMode) {
      print(result.size);
    }
    List<dynamic> convert = result.docs as List;
    if (kDebugMode) {
      print(convert.length);
    }
    _list = convert.map((doc) => Requisicao.fromMap(doc.data(),doc.id)).toList();
    if (kDebugMode) {
      print(_list.length);
    }
    return _list;    
  }

//editar
Future<void> update(Requisicao task) async {
  try {
    await _firestore.collection('requisicao').doc(task.id).update({
      'nameMachine': task.nameMachine,
      'machineId': task.machineId,
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

  


