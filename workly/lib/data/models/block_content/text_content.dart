import 'package:workly/data/models/block_content/block_content.dart';

class TextContent implements BlockContent {
  final String text;

  TextContent(this.text);

  factory TextContent.fromJson(Map<String, dynamic> json) =>
      TextContent(json['text']);

  @override
  Map<String, dynamic> toJson() => {'text': text};
}
