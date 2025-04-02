import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workly/data/repositories/project/project_repository.dart';

class SupabaseProjectRepository implements ProjectRepository {
  @override
  Future<void> createProject(String name) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception('로그인된 사용자가 없습니다.');

    await Supabase.instance.client.from('project').insert({
      'name': name,
      'owner_id': user.id,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> loadProjects() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];

    final result = await Supabase.instance.client
        .from('project')
        .select()
        .eq('owner_id', user.id)
        .order('created_at');

    return List<Map<String, dynamic>>.from(result);
  }
}
