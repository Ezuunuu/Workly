import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'block.dart';

class Document extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String ownerId;
  final DateTime createdAt;
  final List<Block> blocks;

  const Document({
    required this.id,
    required this.projectId,
    required this.title,
    required this.ownerId,
    required this.createdAt,
    required this.blocks,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json['id'],
    projectId: json['project_id'],
    title: json['title'],
    ownerId: json['owner_id'],
    createdAt:
        json['created_at'] is String
            ? DateTime.parse(json['created_at'])
            : (json['created_at'] as Timestamp).toDate(),
    blocks: [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'project_id': projectId,
    'title': title,
    'owner_id': ownerId,
    'created_at': Timestamp.fromDate(createdAt),
    'blocks': blocks.map((b) => b.toJson()).toList(),
  };

  Document copyWith({
    String? id,
    String? projectId,
    String? title,
    String? ownerId,
    DateTime? createdAt,
    List<Block>? blocks,
  }) {
    return Document(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      blocks: blocks ?? this.blocks,
    );
  }

  @override
  List<Object?> get props => [id, projectId, title, ownerId, createdAt, blocks];
}
