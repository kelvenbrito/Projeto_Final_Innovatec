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
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRStock', style: TextStyle(color: Colors.white),),
        
        backgroundColor: Colors.black, // Background preto para o header
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.logoutUsuario();
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _acessarInterna,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
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
  if (_formKey.currentState!.validate()) {
    try {
      return await _auth.loginUsuario(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } catch (e) {
      // Exibir mensagem de erro no SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
  return null;
}


Future<void> _acessarInterna() async {
  User? user = await _loginUser();
  if (user != null) {
    await _saveUserEmail();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InternaScreen(
          user: user,
          userId: user.uid,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login realizado com sucesso!")),
    );
  } else {
    // A mensagem de erro já será exibida no método `_loginUser`.
    _emailController.clear();
    _passwordController.clear();
  }
}


  Future<void> _saveUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', _emailController.text);
  }
}
