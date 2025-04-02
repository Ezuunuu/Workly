import 'block_content.dart';

class TableContent implements BlockContent {
  final List<List<String>> rows;

  TableContent(this.rows);

  factory TableContent.fromJson(Map<String, dynamic> json) => TableContent(
    (json['rows'] as List).map((r) => List<String>.from(r)).toList(),
  );

  @override
  Map<String, dynamic> toJson() => {'rows': rows};
}
