import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/todolist.dart';

class TodolistController{
  //atributo list
  List<Todolist> _list = [];
  List<Todolist> get list => _list;

  //conectar ao firebase FireStore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //métodos
  //add
  Future<void> add(Todolist todolist) async{
    await _firestore.collection('todolist').add(todolist.toMap());
  }
  //deletar
  Future<void> delete(String id) async{
    print(id);
    await _firestore.collection('todolist').doc(id).delete();
    print("ok");
  }
  //fetch list
  Future<List<Todolist>> fetchList(String userId) async{
    final QuerySnapshot result = await _firestore.collection(
      'todolist')
      .where(
        'userid',
         isEqualTo: userId)
         .get();
    print(result.size);
    List<dynamic> convert = result.docs as List;
    print(convert.length);
    _list = convert.map((doc) => Todolist.fromMap(doc.data(),doc.id)).toList();
    print(_list.length);
    return _list;    
  }

  //editar
Future<void> update(Todolist task) async {
  try {
    await _firestore.collection('todolist').doc(task.id).update({
      'titulo': task.titulo,
    
    });
  } catch (e) {
    // Trate qualquer erro que possa ocorrer durante a atualização
    print("Erro ao atualizar tarefa: $e");
    throw Exception("Erro ao atualizar tarefa");
  }
}

  
}

  


