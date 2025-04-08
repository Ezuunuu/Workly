part of 'project_cubit.dart';

enum ProjectStatus { init, loading, success, failure }

class ProjectState extends Equatable {
  final ProjectStatus status;
  final List<Project> projects;
  final Project? currentProject;
  final String? errorMessage;

  const ProjectState({
    this.status = ProjectStatus.init,
    this.projects = const [],
    this.currentProject,
    this.errorMessage,
  });

  ProjectState copyWith({
    ProjectStatus? status,
    List<Project>? projects,
    Project? currentProject,
    String? errorMessage,
  }) {
    return ProjectState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      currentProject: currentProject ?? this.currentProject,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, projects, currentProject, errorMessage];
}
