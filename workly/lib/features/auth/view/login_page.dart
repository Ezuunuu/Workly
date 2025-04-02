import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workly/data/auth/authentication_repository.dart';
import 'package:workly/features/auth/view/registration_page.dart';
import 'package:workly/features/home/view/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _rememberMe = false;
  bool isLoading = false;
  String? errorMessage;

  final authRepo = GetIt.I<AuthenticationRepository>();

  Future<void> _login() async {
    setState(() => isLoading = true);
    try {
      await authRepo.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      await authRepo.ensureUserProfile();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_login', _rememberMe);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      setState(() => errorMessage = '로그인 실패: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('로그인', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: '이메일'),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: '비밀번호'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() => _rememberMe = value ?? false);
                      },
                    ),
                    const Text('로그인 기억하기'),
                  ],
                ),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  child:
                      isLoading
                          ? const CircularProgressIndicator()
                          : const Text('로그인'),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      ),
                  child: const Text('회원가입이 필요하신가요? 가입하기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
