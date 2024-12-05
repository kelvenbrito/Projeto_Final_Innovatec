import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_somativa/screens/requisicao_screen.dart';

class PesquisaMaquinas extends StatefulWidget {
  const PesquisaMaquinas({super.key});

  @override
  _PesquisaMaquinasState createState() => _PesquisaMaquinasState();
}

class _PesquisaMaquinasState extends State<PesquisaMaquinas> {
  String? idMaquina; // Variável para armazenar o ID digitado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar Máquinas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Digite o ID da Máquina',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  idMaquina =
                      value.trim(); // Atualiza o ID conforme o usuário digita
                });
              },
            ),
          ),
          Expanded(
            child: idMaquina == null || idMaquina!.isEmpty
                ? const Center(
                    child: Text('Digite um ID para buscar.'),
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('maquinas')
                        .where('idMaquina', isEqualTo: idMaquina)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Erro ao carregar dados'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                              'Nenhuma máquina encontrada com ID: $idMaquina'),
                        );
                      }

                      // Convertendo os documentos em uma lista
                      final maquinas = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: maquinas.length,
                        itemBuilder: (context, index) {
                          final maquina = maquinas[index];
                          final nomeMaquina = maquina['nomeMaquina'];
                          final nomePeca = maquina['nomePeca'];
                          final idPeca = maquina['idPeca'];
                          final descricao = maquina['descricao'];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text('Máquina: $nomeMaquina'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Descrição: $descricao'),
                                  Text('Peça: $nomePeca (ID: $idPeca)'),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RequisicaoScreen(
                                      userId:
                                          "user123", // Exemplo de userId, substitua se necessário
                                      machineData: {
                                        'idMaquina': maquina['idMaquina'],
                                        'nomeMaquina': nomeMaquina,
                                        'descricao': descricao,
                                        'nomePeca': nomePeca,
                                        'idPeca': idPeca,
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
