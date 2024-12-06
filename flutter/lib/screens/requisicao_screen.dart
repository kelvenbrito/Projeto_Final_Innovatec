import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../controllers/requisicao_controller.dart';
import '../models/requisicao.dart';

class RequisicaoScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> machineData;

  const RequisicaoScreen({super.key, required this.userId,   required this.machineData,});

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
@override
void initState() {
  super.initState();
  final machineData = widget.machineData;
  _machineController.text = machineData['idMaquina'] ?? '';
  _nameController.text = machineData['nomeMaquina'] ?? '';
  _descriptionController.text = machineData['descricao'] ?? '';
  _nomePecaController.text = machineData['nomePeca'] ?? '';
  _qtdPecaController.text = ''; // Este campo pode ser preenchido manualmente

  _fetchRequisicoes(); // Chamando após preencher os dados iniciais
}


  Future<void> _fetchRequisicoes() async {
    await _controller.fetchList(widget.userId);
    if (kDebugMode) {
      print('Requisições carregadas: ${_controller.list}');
    }
    setState(() {});
  }

  void _addRequisicao() async {
    if (_descriptionController.text.isNotEmpty &&
        _machineController.text.isNotEmpty) {
      final requisicao = Requisicao(
        id: '',
        description: _descriptionController.text,
        userId: widget.userId,
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
      _qtdPecaController.clear;
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
                Navigator.of(context).pop(); // Fecha o diálogo sem salvar
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Atualiza o objeto requisicao com os novos valores
                requisicao.nameMachine = _nameController.text;
                requisicao.machineId = _machineController.text;
                requisicao.description = _descriptionController.text;
                requisicao.nomePeca = _nameController.text;
                requisicao.qtdPeca = _qtdPecaController.text;

                // Atualiza a requisição no backend
                await _controller.update(requisicao);

                // Limpa os controladores
                _descriptionController.clear();
                _machineController.clear();
                _nameController.clear();
                _nomePecaController.text = requisicao.nomePeca;
                _qtdPecaController.text = requisicao.qtdPeca;

                // Atualiza a lista
                _fetchRequisicoes();

              
                Navigator.of(context).pop(); // Fecha o diálogo
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
)

        ],
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController
        .dispose(); // Libera recursos do controlador de descrição
    _machineController.dispose(); // Libera recursos do controlador de máquina
    _nameController.dispose(); // Libera recursos do controlador de nome
    _nomePecaController.dispose();
    _qtdPecaController.dispose();
    super.dispose(); // Chama o método dispose() da classe base
  }
}