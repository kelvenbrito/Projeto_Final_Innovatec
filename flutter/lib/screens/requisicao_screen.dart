import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../controllers/requisicao_controller.dart';
import '../models/requisicao.dart';

class RequisicaoScreen extends StatefulWidget {
  final String userEmail;  // Alterado para userEmail
  final Map<String, dynamic> machineData;

  const RequisicaoScreen({super.key, required this.userEmail, required this.machineData});

  @override
  State<RequisicaoScreen> createState() => _RequisicaoScreenState();
}

class _RequisicaoScreenState extends State<RequisicaoScreen> {
  final RequisicaoController _controller = RequisicaoController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _machineController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nomePecaController = TextEditingController();
  final TextEditingController _qtdPecaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final machineData = widget.machineData;
    _machineController.text = machineData['idMaquina'] ?? '';
    _nameController.text = machineData['nomeMaquina'] ?? '';
    _descriptionController.text = machineData['descricao'] ?? '';
    _nomePecaController.text = machineData['nomePeca'] ?? '';
    _qtdPecaController.text = '';

    _fetchRequisicoes();
  }

  Future<void> _fetchRequisicoes() async {
    await _controller.fetchList(widget.userEmail);  // Alterado para userEmail
    setState(() {});
  }

  void _addRequisicao() async {
    if (_descriptionController.text.isNotEmpty &&
        _machineController.text.isNotEmpty) {
      final requisicao = Requisicao(
        id: '',
        description: _descriptionController.text,
        userEmail: widget.userEmail,  // Alterado para userEmail
        machineId: _machineController.text,
        nameMachine: _nameController.text,
        nomePeca: _nomePecaController.text,
        qtdPeca: _qtdPecaController.text,
        timestamp: DateTime.now(),
      );

      await _controller.add(requisicao);
      _descriptionController.clear();
      _machineController.clear();
      _nameController.clear();
      _nomePecaController.clear();
      _qtdPecaController.clear();
      _fetchRequisicoes();
    }
  }

  void _deleteRequisicao(String id) async {
    await _controller.delete(id);
    _fetchRequisicoes();
  }

  void _editRequisicaoDialog(Requisicao requisicao) {
    _descriptionController.text = requisicao.description;
    _machineController.text = requisicao.machineId;
    _nameController.text = requisicao.nameMachine;
    _nomePecaController.text = requisicao.nomePeca;
    _qtdPecaController.text = requisicao.qtdPeca;

    DropdownButton<String>(
      value: requisicao.status,
      items: ['em aberto', 'concluido', 'finalizado']
          .map((status) => DropdownMenuItem(
                value: status,
                child: Text(status),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            requisicao.status = value;
          });
        }
      },
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Requisição'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _machineController,
                decoration: const InputDecoration(labelText: 'ID da Máquina'),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome da Máquina'),
              ),
              TextField(
                controller: _nomePecaController,
                decoration: const InputDecoration(labelText: 'Nome da Peca'),
              ),
              TextField(
                controller: _qtdPecaController,
                decoration:
                    const InputDecoration(labelText: 'Quantidades de peças'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                requisicao.nameMachine = _nameController.text;
                requisicao.machineId = _machineController.text;
                requisicao.description = _descriptionController.text;
                requisicao.nomePeca = _nomePecaController.text;
                requisicao.qtdPeca = _qtdPecaController.text;

                await _controller.update(requisicao);

                _fetchRequisicoes();
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
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
                  controller: _machineController,
                  decoration: const InputDecoration(labelText: 'ID da Máquina'),
                ),
                TextField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'Nome da Máquina'),
                ),
                TextField(
                  controller: _nomePecaController,
                  decoration: const InputDecoration(labelText: 'Nome da Peca'),
                ),
                TextField(
                  controller: _qtdPecaController,
                  decoration:
                      const InputDecoration(labelText: 'Quantidades de peças'),
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
            child: _controller.list.isEmpty
                ? const Center(child: Text('Nenhuma requisição encontrada.'))
                : ListView.builder(
                    itemCount: _controller.list.length,
                    itemBuilder: (context, index) {
                      final requisicao = _controller.list[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nome da Máquina: ${requisicao.nameMachine}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('ID da Máquina: ${requisicao.machineId}'),
                              const SizedBox(height: 4),
                              Text('Nome da Peça: ${requisicao.nomePeca}'),
                              const SizedBox(height: 4),
                              Text('Quantidade de Peças: ${requisicao.qtdPeca}'),
                              const SizedBox(height: 4),
                              Text('Descrição: ${requisicao.description}'),
                              const SizedBox(height: 4),
                              Text('Status: ${requisicao.status}'),
                              const SizedBox(height: 4),
                              Text(
                                'Data: ${requisicao.timestamp.toString()}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _editRequisicaoDialog(requisicao);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteRequisicao(requisicao.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    _descriptionController.dispose();
    _machineController.dispose();
    _nameController.dispose();
    _nomePecaController.dispose();
    _qtdPecaController.dispose();
    super.dispose();
  }
}
