import 'package:workly/data/models/block.dart';

import 'text_content.dart';
import 'image_content.dart';
import 'checkbox_content.dart';
import 'table_content.dart';

abstract class BlockContent {
  Map<String, dynamic> toJson();
  factory BlockContent.fromJson(BlockType type, Map<String, dynamic> json) {
    switch (type) {
      case BlockType.text:
        return TextContent.fromJson(json);
      case BlockType.image:
        return ImageContent.fromJson(json);
      case BlockType.checkbox:
        return CheckboxContent.fromJson(json);
      case BlockType.table:
        return TableContent.fromJson(json);
    }
  }

  factory BlockContent.create(BlockType blockType) {
    switch (blockType) {
      case BlockType.text:
        return TextContent('새로운 텍스트');
      case BlockType.image:
        return ImageContent('https://example.com/image.jpg');
      case BlockType.checkbox:
        return CheckboxContent('새로운 체크박스', false);
      case BlockType.table:
        return TableContent([
          ['Row 1', 'Row 2'],
          ['Row 3', 'Row 4'],
        ]);
      default:
        throw Exception('Unknown BlockType: $blockType');
    }
  }
}
