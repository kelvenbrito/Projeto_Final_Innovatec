import 'package:flutter/material.dart';
import 'package:flutter_somativa/screens/todolist_screen.dart';
import 'package:flutter_somativa/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, K});

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey, // Associa a chave global ao formulário
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController, // Associa o controlador ao campo de email
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController, // Associa o controlador ao campo de senha
                  decoration: const InputDecoration(hintText: 'Senha'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha';
                    }
                    return null;
                  },
                  obscureText: true, // Oculta o texto da senha
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _acessarTodoList(); // Chama o método para acessar a lista de tarefas
                  },
                  child: const Text("Login"),
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodolistScreen(user: user), // Navega para a tela de lista de tarefas
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
