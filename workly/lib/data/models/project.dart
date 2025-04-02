import 'package:workly/data/models/document.dart';
import 'package:workly/data/models/task.dart';
import 'package:workly/data/models/whiteboard.dart';

class Project {
  final String id;
  final String name;
  final String ownerId;
  final DateTime createdAt;

  final List<Document> documents;
  final List<Task> tasks;
  final List<Whiteboard> whiteboards;

  Project({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.createdAt,
    this.documents = const [],
    this.tasks = const [],
    this.whiteboards = const [],
  });
}
