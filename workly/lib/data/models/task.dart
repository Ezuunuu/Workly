import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.projectId,
    required this.title,
    required this.isDone,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'] ?? json['created_at'];
    return Task(
      id: json['id'],
      projectId: json['projectId'] ?? json['project_id'],
      title: json['title'],
      isDone: json['isDone'] ?? json['is_done'] ?? false,
      createdAt:
          createdAt is Timestamp
              ? createdAt.toDate()
              : DateTime.tryParse(createdAt.toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'title': title,
    'isDone': isDone,
    'createdAt': createdAt.toIso8601String(),
  };

  Task copyWith({
    String? id,
    String? projectId,
    String? title,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, projectId, title, isDone, createdAt];
}
