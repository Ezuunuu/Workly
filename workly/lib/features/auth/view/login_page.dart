import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:workly/data/auth/authentication_repository.dart';
import 'package:workly/features/auth/view/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthenticationRepository authRepository =
      GetIt.I<AuthenticationRepository>();

  bool isLoading = false;
  String? errorMessage;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await authRepository.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Workly 로그인',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: '이메일'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '비밀번호'),
              ),
              const SizedBox(height: 24),
              if (errorMessage != null) ...[
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],
              ElevatedButton(
                onPressed: isLoading ? null : _login,
                child:
                    isLoading
                        ? const CircularProgressIndicator()
                        : const Text('로그인'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: const Text('회원가입이 필요하신가요? 가입하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
