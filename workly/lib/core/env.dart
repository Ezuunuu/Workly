import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AuthProviderType { firebase, supabase }

const AuthProviderType currentAuthProvider = AuthProviderType.supabase;

final supabaseUrl = dotenv.env['SUPABASE_URL']!;
final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;
final supabaseAuthPassword = dotenv.env['SUPABASE_PASSWORD']!;
