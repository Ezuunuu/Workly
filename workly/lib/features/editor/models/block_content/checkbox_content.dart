import 'block_content.dart';

class CheckboxContent implements BlockContent {
  final String label;
  final bool checked;

  CheckboxContent(this.label, this.checked);

  factory CheckboxContent.fromJson(Map<String, dynamic> json) =>
      CheckboxContent(json['label'], json['checked']);

  @override
  Map<String, dynamic> toJson() => {'label': label, 'checked': checked};
}
