import 'package:cloud_firestore/cloud_firestore.dart';

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
    print(id);
    await _firestore.collection('requisicao').doc(id).delete();
    print("ok");
  }
  //fetch list
  Future<List<Requisicao>> fetchList(String userId) async{
    final QuerySnapshot result = await _firestore.collection(
      'requisicao')
      .where(
        'userid',
         isEqualTo: userId)
         .get();
    print(result.size);
    List<dynamic> convert = result.docs as List;
    print(convert.length);
    _list = convert.map((doc) => Requisicao.fromMap(doc.data(),doc.id)).toList();
    print(_list.length);
    return _list;    
  }

  //editar
Future<void> update(Requisicao task) async {
  try {
    await _firestore.collection('requisicao').doc(task.id).update({
      'titulo': task.titulo,
    
    });
  } catch (e) {
    // Trate qualquer erro que possa ocorrer durante a atualização
    print("Erro ao atualizar tarefa: $e");
    throw Exception("Erro ao atualizar tarefa");
  }
}

  
}

  


