import 'package:firebase_auth/firebase_auth.dart';
import 'authentication_repository.dart';

class FirebaseAuthRepository implements AuthenticationRepository {
  @override
  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signUp(String email, String password, String name) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(name);
  }
}
