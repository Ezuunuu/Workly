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
}
