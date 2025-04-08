import 'package:workly/data/models/project.dart';

abstract class ProjectRepository {
  Future<void> createProject(String name);
  Future<List<Map<String, dynamic>>> loadProjects();
  Future<Project> loadProjectById(String projectId);
}
