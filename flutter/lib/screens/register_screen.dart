import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_somativa/screens/interna_screen.dart';
import 'package:flutter_somativa/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _service = AuthService(); // Instância do serviço de autenticação
  final TextEditingController _emailController = TextEditingController(); // Controlador para o campo de email
  final TextEditingController _passwordController = TextEditingController(); // Controlador para o campo de senha
  final TextEditingController _confirmedPasswordController = TextEditingController(); // Controlador para o campo de confirmação de senha
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Chave global para validar o formulário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Conta'),
        backgroundColor: Colors.black, // Cor do app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Aumenta o padding para melhor disposição dos itens
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
                    labelText: 'E-mail',
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
                    if (value!.trim().isEmpty) {
                      return "Insira o email";
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
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Insira a senha";
                    } else if (value.length < 6) {
                      return "A senha deve ter pelo menos 6 caracteres";
                    }
                    return null;
                  },
                  obscureText: true, // Oculta o texto da senha
                ),
                const SizedBox(height: 20),
                // Campo de Confirmar Senha
                TextFormField(
                  controller: _confirmedPasswordController, // Associa o controlador ao campo de confirmação de senha
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Confirme a senha";
                    } else if (value != _passwordController.text) {
                      return "As senhas não conferem";
                    }
                    return null;
                  },
                  obscureText: true, // Oculta o texto da confirmação de senha
                ),
                const SizedBox(height: 20),
                // Botão de Registro
                ElevatedButton(
                  onPressed: () => _registrarUser(context), // Chama o método para registrar o usuário
                  child: const Text('Registrar'),
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
Future<void> _registrarUser(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    try {
      // Registra o usuário e obtém o User do Firebase
      User? user = await _service.registerUsuario(
        _emailController.text,
        _passwordController.text,
      );

      if (user != null) {
        String userId = user.uid; // Recupera o ID do usuário registrado

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário registrado com sucesso!'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navega para a página de login ou para a próxima tela com o userId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InternaScreen(user: user, userId: userId),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao registrar usuário: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

}
