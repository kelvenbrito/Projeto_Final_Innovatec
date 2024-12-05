import 'package:flutter/material.dart';
import 'package:flutter_somativa/screens/interna_screen.dart';
import 'package:flutter_somativa/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService(); // Instância do serviço de autenticação
  final _formKey = GlobalKey<FormState>(); // Chave global para validar o formulário
  final TextEditingController _emailController = TextEditingController(); // Controlador para o campo de email
  final TextEditingController _passwordController = TextEditingController(); // Controlador para o campo de senha

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRStock'),
        backgroundColor: Colors.black, // Cor preta para o header
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Aumenta o padding para melhorar o layout
        child: Center(
          child: Form(
            key: _formKey, // Associa a chave global ao formulário
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Campo de Email
                TextFormField(
                  controller: _emailController, // Associa o controlador ao campo de email
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Campo de Senha
                TextFormField(
                  controller: _passwordController, // Associa o controlador ao campo de senha
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha';
                    }
                    return null;
                  },
                  obscureText: true, // Oculta o texto da senha
                ),
                const SizedBox(height: 20),
                // Botão de Login
                ElevatedButton(
                  onPressed: () {
                    _acessarTodoList(); // Chama o método para acessar a lista de tarefas
                  },
                  child: const Text("Login"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.grey, // Cor do texto preto
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<User?> _loginUser() async {
    if (_formKey.currentState!.validate()) { // Valida o formulário
      return await _auth.loginUsuario(
        _emailController.text,
        _passwordController.text,
      );
    }
    return null;
  }

Future<void> _acessarTodoList() async {
  User? user = await _loginUser(); // Tenta realizar o login do usuário
  if (user != null) {
    String userId = user.uid; // Recupera o ID do usuário logado

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InternaScreen(user: user, userId: userId), // Passa o ID do usuário para a próxima tela
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login realizado com sucesso!"), // Mostra um snackbar de sucesso
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Usuário ou senha inválidos"), // Mostra um snackbar de erro
      ),
    );
    _emailController.clear(); // Limpa o campo de email
    _passwordController.clear(); // Limpa o campo de senha
  }
}

}
