import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workly/data/models/project.dart';
import 'package:workly/data/repositories/project/project_repository.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit({required this.repository}) : super(const ProjectState());
  final ProjectRepository repository;

  Future<void> loadProjects() async {
    emit(state.copyWith(status: ProjectStatus.loading));
    try {
      final result = await repository.loadProjects();
      final projects = result.map((json) => Project.fromJson(json)).toList();
      emit(state.copyWith(status: ProjectStatus.success, projects: projects));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProjectStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadProjectById(String projectId) async {
    emit(state.copyWith(status: ProjectStatus.loading));
    try {
      final project = await repository.loadProjectById(projectId);
      emit(
        state.copyWith(status: ProjectStatus.success, currentProject: project),
      );
    } catch (e) {
      emit(state.copyWith(status: ProjectStatus.failure));
    }
  }

  Future<void> addProject(String name) async {
    try {
      await repository.createProject(name);
      await loadProjects();
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProjectStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void reset() {
    emit(const ProjectState());
  }
}
