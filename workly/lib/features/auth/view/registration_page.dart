import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:workly/data/auth/authentication_repository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final authRepo = GetIt.I<AuthenticationRepository>();
  bool isLoading = false;
  String? errorMessage;

  Future<void> _register() async {
    setState(() => isLoading = true);
    try {
      await authRepo.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
      );
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("회원가입 완료"),
              content: const Text(
                "입력하신 이메일로 인증 링크가 전송되었어요!\n이메일 인증 후 로그인해주세요.",
              ),
              actions: [
                TextButton(
                  onPressed:
                      () =>
                          Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text("확인"),
                ),
              ],
            ),
      );
    } catch (e) {
      print(e);
      setState(() => errorMessage = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('회원가입', style: Theme.of(context).textTheme.headlineLarge),
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
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            const SizedBox(height: 20),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: isLoading ? null : _register,
              child:
                  isLoading
                      ? const CircularProgressIndicator()
                      : const Text('가입하기'),
            ),
          ],
        ),
      ),
    );
  }
}
