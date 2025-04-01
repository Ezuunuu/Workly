import 'package:cloud_firestore/cloud_firestore.dart';

import 'block.dart';

class Document {
  final String id;
  final String title;
  final String ownerId;
  final DateTime createdAt;
  final List<Block> blocks;

  Document({
    required this.id,
    required this.title,
    required this.ownerId,
    required this.createdAt,
    required this.blocks,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json['id'],
    title: json['title'],
    ownerId: json['ownerId'],
    createdAt: (json['createdAt'] as Timestamp).toDate(),
    blocks: (json['blocks'] as List)
        .map((b) => Block.fromJson(b))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ownerId': ownerId,
    'createdAt': Timestamp.fromDate(createdAt),
    'blocks': blocks.map((b) => b.toJson()).toList(),
  };
}