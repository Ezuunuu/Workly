import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workly/core/env.dart';
import 'package:workly/data/auth/authentication_repository.dart';
import 'package:workly/data/auth/firebase_auth_repository.dart';
import 'package:workly/data/auth/supabase_auth_repository.dart';
import 'package:workly/data/repositories/project/firebase_project_repository.dart';
import 'package:workly/data/repositories/project/project_repository.dart';
import 'package:workly/data/repositories/project/supabase_project_repository.dart';
import '../features/editor/cubit/editor_cubit.dart';
import '../data/repositories/document_repository.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Repository 등록
  if (currentAuthProvider == AuthProviderType.firebase) {
    await Firebase.initializeApp();
    getIt.registerLazySingleton<AuthenticationRepository>(
      () => FirebaseAuthRepository(),
    );
    getIt.registerLazySingleton<ProjectRepository>(
      () => FirebaseProjectRepository(),
    );
  } else if ((currentAuthProvider == AuthProviderType.supabase)) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    getIt.registerLazySingleton<AuthenticationRepository>(
      () => SupabaseAuthRepository(),
    );
    getIt.registerLazySingleton<ProjectRepository>(
      () => SupabaseProjectRepository(),
    );
  }

  // Bloc 등록
  getIt.registerFactory<EditorCubit>(
    () => EditorCubit(documentRepository: getIt<DocumentRepository>()),
  );
}
