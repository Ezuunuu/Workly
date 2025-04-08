import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:workly/data/models/document.dart';
import 'package:workly/data/models/task.dart';
import 'package:workly/data/models/whiteboard.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String ownerId;
  final DateTime createdAt;

  final List<Document> documents;
  final List<Task> tasks;
  final List<Whiteboard> whiteboards;

  const Project({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.createdAt,
    this.documents = const [],
    this.tasks = const [],
    this.whiteboards = const [],
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'] ?? json['created_at'];
    return Project(
      id: json['id'],
      name: json['name'],
      ownerId: json['ownerId'] ?? json['owner_id'],
      createdAt:
          createdAt is Timestamp
              ? createdAt.toDate()
              : DateTime.tryParse(createdAt.toString()) ?? DateTime.now(),
      documents:
          (json['documents'] as List? ?? [])
              .map((e) => Document.fromJson(e))
              .toList(),
      tasks:
          (json['tasks'] as List? ?? []).map((e) => Task.fromJson(e)).toList(),
      whiteboards:
          (json['whiteboards'] as List? ?? [])
              .map((e) => Whiteboard.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ownerId': ownerId,
    'createdAt': createdAt.toIso8601String(),
    'documents': documents.map((d) => d.toJson()).toList(),
    'tasks': tasks.map((t) => t.toJson()).toList(),
    'whiteboards': whiteboards.map((w) => w.toJson()).toList(),
  };

  Project copyWith({
    String? id,
    String? name,
    String? ownerId,
    DateTime? createdAt,
    List<Document>? documents,
    List<Task>? tasks,
    List<Whiteboard>? whiteboards,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      documents: documents ?? this.documents,
      tasks: tasks ?? this.tasks,
      whiteboards: whiteboards ?? this.whiteboards,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    ownerId,
    createdAt,
    documents,
    tasks,
    whiteboards,
  ];
}
