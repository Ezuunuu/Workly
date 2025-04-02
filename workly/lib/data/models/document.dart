import 'package:cloud_firestore/cloud_firestore.dart';

import 'block.dart';

class Document {
  final String id;
  final String projectId;
  final String title;
  final String ownerId;
  final DateTime createdAt;
  final List<Block> blocks;

  Document({
    required this.id,
    required this.projectId,
    required this.title,
    required this.ownerId,
    required this.createdAt,
    required this.blocks,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json['id'],
    projectId: json['projectId'],
    title: json['title'],
    ownerId: json['ownerId'],
    createdAt: (json['createdAt'] as Timestamp).toDate(),
    blocks: (json['blocks'] as List).map((b) => Block.fromJson(b)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'title': title,
    'ownerId': ownerId,
    'createdAt': Timestamp.fromDate(createdAt),
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
}
