import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //atributio
  final FirebaseAuth _auth = FirebaseAuth.instance;

   // Método de registro
  Future<User?> registerUsuario(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Retorna o usuário registrado
    } catch (e) {
      rethrow;
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
    } catch (e) {
      rethrow;
    }
  }

  //logout user
  Future<void> logoutUsuario() async{
    try{
      await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }


}