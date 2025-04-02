import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'authentication_repository.dart';

class SupabaseAuthRepository implements AuthenticationRepository {
  @override
  Future<void> signIn(String email, String password) async {
    await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signUp(String email, String password, String name) async {
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user != null) {
      return;
    } else {
      throw AuthException('회원가입에 실패했습니다.');
    }
  }

  @override
  Future<void> ensureUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final existing =
        await Supabase.instance.client
            .from('user_profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

    if (existing == null) {
      await Supabase.instance.client.from('user_profiles').insert({
        'id': user.id,
        'email': user.email,
        'name': user.userMetadata?['name'] ?? '사용자',
      });
    }
  }

  @override
  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remember_login');
  }
}
