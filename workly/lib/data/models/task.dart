class Task {
  final String id;
  final String projectId;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.projectId,
    required this.title,
    required this.isDone,
    required this.createdAt,
  });
}
