import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Whiteboard extends Equatable {
  final String id;
  final String projectId;
  final String name;
  final DateTime createdAt;

  const Whiteboard({
    required this.id,
    required this.projectId,
    required this.name,
    required this.createdAt,
  });

  factory Whiteboard.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'] ?? json['created_at'];
    return Whiteboard(
      id: json['id'],
      projectId: json['projectId'] ?? json['project_id'],
      name: json['name'],
      createdAt:
          createdAt is Timestamp
              ? createdAt.toDate()
              : DateTime.tryParse(createdAt.toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
  };

  Whiteboard copyWith({
    String? id,
    String? projectId,
    String? name,
    DateTime? createdAt,
  }) {
    return Whiteboard(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, projectId, name, createdAt];
}
