import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workly/features/auth/view/login_page.dart';
import 'package:workly/features/home/view/home_page.dart';
import 'core/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/env.dart';

class App extends StatelessWidget {
  const App({super.key});

  Future<Widget> _resolveStartPage() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberLogin = prefs.getBool('remember_login') ?? false;

    if (!rememberLogin) return const LoginPage();

    if (currentAuthProvider == AuthProviderType.supabase) {
      final session = Supabase.instance.client.auth.currentSession;
      return session != null ? const HomePage() : const LoginPage();
    } else {
      final user = FirebaseAuth.instance.currentUser;
      return user != null ? const HomePage() : const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _resolveStartPage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        return MaterialApp(
          title: 'Workly',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          home: snapshot.data,
        );
      },
    );
  }
}
