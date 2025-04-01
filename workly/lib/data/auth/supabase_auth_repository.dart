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
      // 이메일 인증 메일 전송 후, 이후 로그인 시점에 프로필 생성 권장
      return;
    } else {
      throw AuthException('회원가입에 실패했습니다.');
    }
  }
}
