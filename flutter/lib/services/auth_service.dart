import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Atributo
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método de registro
  Future<User?> registerUsuario(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Retorna o usuário registrado
    } on FirebaseAuthException catch (e) {
      // Tratamento de erros específicos
      if (e.code == 'email-already-in-use') {
        throw Exception('O e-mail já está em uso.');
      } else if (e.code == 'weak-password') {
        throw Exception('A senha é muito fraca.');
      } else if (e.code == 'invalid-email') {
        throw Exception('O e-mail informado é inválido.');
      } else {
        throw Exception('Erro ao registrar: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erro desconhecido: $e');
    }
  }

  // Método de login
Future<User?> loginUsuario(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user; // Retorna o usuário logado
  } on FirebaseAuthException catch (e) {
    // Trata os códigos de erro do FirebaseAuth
    switch (e.code) {
      case 'user-not-found':
        throw Exception('Usuário não encontrado. Verifique o e-mail.');
      case 'wrong-password':
        throw Exception('Senha incorreta. Tente novamente.');
      case 'invalid-email':
        throw Exception('E-mail inválido. Por favor, corrija.');
      default:
        throw Exception('Erro ao fazer login: ${e.message}');
    }
  }
}

  // Logout
  Future<void> logoutUsuario() async {
    try {
      await _auth.signOut();
    } catch (e) {
   
      throw Exception('Erro ao deslogar: $e');
    }
  }
}
