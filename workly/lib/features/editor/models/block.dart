import 'dart:ui';
import 'package:workly/features/editor/models/block_content/block_content.dart';

enum BlockType { text, image, checkbox, table }

class Block {
  Block({
    required this.id,
    required this.type,
    required this.content,
    required this.order,
    required this.position,
    required this.size,
  });

  final String id;
  final BlockType type;
  BlockContent content;
  int order;
  Offset position;
  Size size;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'content': content.toJson(),
    'order': order,
    'position': {'x': position.dx, 'y': position.dy},
    'size': {'width': size.width, 'height': size.height},
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
      (json['position']['x'] as num).toDouble(),
      (json['position']['y'] as num).toDouble(),
    ),
    size: Size(
      (json['size']['width'] as num).toDouble(),
      (json['size']['height'] as num).toDouble(),
    ),
  );
}
