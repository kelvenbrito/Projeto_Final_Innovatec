import 'package:flutter/material.dart';
import '../controllers/requisicao_controller.dart';
import '../models/requisicao.dart';

class RequisicaoScreen extends StatefulWidget {
  final String userId;

  const RequisicaoScreen({super.key, required this.userId});

  @override
 State<RequisicaoScreen> createState() => _RequisicaoScreenState();
}


class _RequisicaoScreenState extends State<RequisicaoScreen> {
  final RequisicaoController _controller = RequisicaoController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _machineController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRequisicoes();
  }

  Future<void> _fetchRequisicoes() async {
    await _controller.fetchList(widget.userId);
    setState(() {});
  }

  void _addRequisicao() async {
    if (_descriptionController.text.isNotEmpty && _machineController.text.isNotEmpty) {
      final requisicao = Requisicao(
        id: '',
        description: _descriptionController.text,
        userId: widget.userId,
        machineId: _machineController.text,
        nameMachine: _nameController.text,
        timestamp: DateTime.now(),
      );

      await _controller.add(requisicao);
      _descriptionController.clear();
      _machineController.clear();
      _nameController.clear();
      _fetchRequisicoes();
    }
  }

  void _deleteRequisicao(String id) async {
    await _controller.delete(id);
    _fetchRequisicoes();
  }

  void _updateRequisicao(Requisicao requisicao) async {
    requisicao.description = _descriptionController.text;
    await _controller.update(requisicao);
    _descriptionController.clear();
    _fetchRequisicoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requisições'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome da Máquina'),
                ),
                TextField(
                  controller: _machineController,
                  decoration: const InputDecoration(labelText: 'ID da Máquina'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                ElevatedButton(
                  onPressed: _addRequisicao,
                  child: const Text('Adicionar Requisição'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _controller.list.length,
              itemBuilder: (context, index) {
                final requisicao = _controller.list[index];
                return ListTile(
                  title: Text(requisicao.nameMachine),
                  subtitle: Text(requisicao.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _descriptionController.text = requisicao.description;
                          _updateRequisicao(requisicao);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteRequisicao(requisicao.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

@override
void dispose() {
  _descriptionController.dispose(); // Libera recursos do controlador de descrição
  _machineController.dispose();    // Libera recursos do controlador de máquina
  _nameController.dispose();       // Libera recursos do controlador de nome
  super.dispose();                 // Chama o método dispose() da classe base
}

}
