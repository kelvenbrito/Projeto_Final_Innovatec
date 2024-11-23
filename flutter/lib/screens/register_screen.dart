import 'package:flutter/material.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Form(
            key: _formKey, // Associa a chave global ao formulário
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController, // Associa o controlador ao campo de email
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Insira o email";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController, // Associa o controlador ao campo de senha
                  decoration: const InputDecoration(
                    labelText: 'Senha',
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
                TextFormField(
                  controller: _confirmedPasswordController, // Associa o controlador ao campo de confirmação de senha
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Senha',
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
                ElevatedButton(
                  onPressed: () => _registrarUser(context), // Chama o método para registrar o usuário ao pressionar o botão
                  child: const Text('Registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registrarUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) { // Valida o formulário
      await _service.registerUsuario( // Chama o método de registro do serviço de autenticação
        _emailController.text,
        _passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário registrado com sucesso!'), // Mostra um snackbar de sucesso
          duration: Duration(seconds: 2),
        ),
      );

      // Navega para a página de login após o registro
      Navigator.pushNamed(context, '/login');
    }
  }
}
