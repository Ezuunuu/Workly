import 'dart:ui';
import 'package:workly/data/models/block_content/block_content.dart';

enum BlockType { text, image, checkbox, table }

class Block {
  Block({
    this.id,
    required this.type,
    required this.content,
    required this.order,
    required this.position,
    required this.size,
  });

  final String? id;
  final BlockType type;
  BlockContent content;
  int order;
  Offset position;
  Size size;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'content': content.toJson(),
    'order': order,
    'x': position.dx,
    'y': position.dy,
    'width': size.width,
    'height': size.height,
  };

  factory Block.fromJson(Map<String, dynamic> json) => Block(
    id: json['id'],
    type: BlockType.values.firstWhere((e) => e.name == json['type']),
    content: BlockContent.fromJson(
      BlockType.values.firstWhere((e) => e.name == json['type']),
      json['content'],
    ),
    order: json['order'],
    position: Offset(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
    ),
    size: Size(
      (json['width'] as num).toDouble(),
      (json['height'] as num).toDouble(),
    ),
  );

  Block copyWith({
    String? id,
    BlockType? type,
    BlockContent? content,
    int? order,
    Offset? position,
    Size? size,
  }) {
    return Block(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      order: order ?? this.order,
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }
}
