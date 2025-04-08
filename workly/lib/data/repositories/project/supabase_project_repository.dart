import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workly/data/models/document.dart';
import 'package:workly/data/models/project.dart';
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

  @override
  Future<Project> loadProjectById(String projectId) async {
    final projectResult =
        await Supabase.instance.client
            .from('project')
            .select()
            .eq('id', projectId)
            .maybeSingle();

    if (projectResult == null) {
      throw Exception('프로젝트를 찾을 수 없습니다.');
    }

    final documentsResult = await Supabase.instance.client
        .from('documents')
        .select()
        .eq('project_id', projectId)
        .order('created_at', ascending: false);

    final documents =
        (documentsResult as List)
            .map((docJson) => Document.fromJson(docJson))
            .toList();

    return Project.fromJson(projectResult).copyWith(documents: documents);
  }
}
