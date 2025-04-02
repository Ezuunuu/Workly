abstract class ProjectRepository {
  Future<void> createProject(String name);
  Future<List<Map<String, dynamic>>> loadProjects();
}
