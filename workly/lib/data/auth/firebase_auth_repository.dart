import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  Future<void> ensureUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('user_profiles')
            .doc(user.uid)
            .get();
    if (!doc.exists) {
      await FirebaseFirestore.instance
          .collection('user_profiles')
          .doc(user.uid)
          .set({
            'id': user.uid,
            'email': user.email,
            'name': user.displayName ?? '사용자',
          });
    }
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remember_login');
  }
}
