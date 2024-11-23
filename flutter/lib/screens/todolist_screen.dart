import 'package:flutter/material.dart';
import 'package:flutter_somativa/controllers/todolist_controller.dart';
import 'package:flutter_somativa/models/todolist.dart';
import 'package:flutter_somativa/screens/geradorQRC.dart';
import 'package:flutter_somativa/screens/leitorQRCodeScreen.dart';
import 'package:flutter_somativa/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodolistScreen extends StatefulWidget {
  final User user;
  const TodolistScreen({super.key, required this.user});

  @override
  State<TodolistScreen> createState() => _TodolistScreenState();
}

class _TodolistScreenState extends State<TodolistScreen> {
  final AuthService _service = AuthService(); 
  final TodolistController _controller = TodolistController(); 
  final _tituloController = TextEditingController(); 
  bool _isList = true; // Define a flag para decidir qual ação do botão será chamada

  Future<void> _getList() async {
    try {
      await _controller.fetchList(widget.user.uid); 
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List Firebase'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _service.logoutUsuario(); 
              Navigator.pushReplacementNamed(context, '/home'); 
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: _getList(),
                  builder: (context, snapshot) {
                    if (_controller.list.isNotEmpty) {
                      return ListView.builder(
                        itemCount: _controller.list.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_controller.list[index].titulo),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(_controller.list[index]);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await _controller.delete(_controller.list[index].id);
                                    _getList();
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          if (_isList) {
             Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScannerPage()), 
            );
          } else {
            // Ação para abrir o Gerador QR Code
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GeradorQRCodeScreen()), 
            );
          }
        },
      ),
      // Alternando entre modos de adicionar tarefa e mostrar o QR Code
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _isList ? 0 : 1, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Scanner QRCode',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Geraador de QRCode',
          ),
        ],
        onTap: (index) {
          setState(() {
            _isList = index == 0;
          });
        },
      ),
    );
  }



  void _showEditDialog(Todolist task) {
    _tituloController.text = task.titulo;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Tarefa"),
          content: TextFormField(
            controller: _tituloController,
            decoration: const InputDecoration(hintText: "Digite a tarefa"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Salvar"),
              onPressed: () async {
                final tarefaAtualizada = Todolist(
                  id: task.id,
                  titulo: _tituloController.text,
                  userId: task.userId,
                  timestamp: task.timestamp,
                );
                await _controller.update(tarefaAtualizada);
                await _getList();
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}
