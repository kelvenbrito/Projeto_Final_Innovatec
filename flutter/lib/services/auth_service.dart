import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //atributio
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //metodo login user
  Future<User?> loginUsuario(String email, String password) async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

    //metodo register user
  Future<void> registerUsuario(String email, String password) async{
    try{
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }catch(e){
      print(e.toString());
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

  //login google firebase
  // Future<User?> loginGoogle() async{
  //   try{
  //     GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  //     GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //     AuthCredential credential = GoogleAuthProvider.getCredential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     UserCredential userCredential = await _auth.signInWithCredential(credential);
  //     return userCredential.user;
  //   }catch(e){
  //     print(e.toString());
  //     return null;
  //   }

  // }

}