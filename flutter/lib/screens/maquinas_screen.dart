import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_somativa/screens/requisicao_screen.dart';
import 'package:flutter_somativa/services/auth_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PesquisaMaquinas extends StatefulWidget {
  final String? qrCodeValue; // Valor escaneado do QR Code
  

  const PesquisaMaquinas({super.key, this.qrCodeValue});

  @override
  _PesquisaMaquinasState createState() => _PesquisaMaquinasState();
}

class _PesquisaMaquinasState extends State<PesquisaMaquinas> {
  String? idMaquina;
    final AuthService _service = AuthService();

  @override
  void initState() {
    super.initState();
    idMaquina = widget.qrCodeValue; // Inicializa com o valor do QR Code
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final qrData = ModalRoute.of(context)?.settings.arguments as String?;
    if (qrData != null && idMaquina == null) {
      setState(() {
        idMaquina = qrData; // Preencher o campo com o valor do QR Code
      });
    }
  }

  // Método para pegar o email salvo no SharedPreferences
  Future<String?> _getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  @override
  Widget build(BuildContext context) {
    
    final qrData = ModalRoute.of(context)!.settings.arguments as String?;
    print('Dados recebidos: $qrData');
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRStock', style: TextStyle(color: Colors.white),),
        
        backgroundColor: Colors.black, // Background preto para o header
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Digite o ID da Máquina',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(
                  text: idMaquina), // Preenche o campo com o ID do QR Code
              onChanged: (value) {
                setState(() {
                  idMaquina = value.trim();
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
                              title: Text('Peça: $nomePeca (ID: $idPeca)'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Descrição: $descricao'),
                                  Text('Máquina: $nomeMaquina'),
                                ],
                              ),
                              onTap: () async {
                                // Recupera o email antes de navegar
                                String? userEmail = await _getUserEmail();

                                // Navega para a próxima tela passando o userEmail
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RequisicaoScreen(
                                      userEmail: userEmail ??
                                          "", // Passa o email (ou uma string vazia se não encontrado)
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
