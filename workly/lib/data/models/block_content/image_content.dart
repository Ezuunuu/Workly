import 'block_content.dart';

class ImageContent implements BlockContent {
  final String url;

  ImageContent(this.url);

  factory ImageContent.fromJson(Map<String, dynamic> json) =>
      ImageContent(json['url']);

  @override
  Map<String, dynamic> toJson() => {'url': url};
}
