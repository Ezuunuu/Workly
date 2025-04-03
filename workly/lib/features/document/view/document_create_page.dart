import 'package:flutter/material.dart';
import 'package:workly/data/repositories/document/document_repository.dart';
import 'package:workly/di/service_locator.dart';

class DocumentCreatePage extends StatefulWidget {
  final String projectId;

  const DocumentCreatePage({super.key, required this.projectId});

  @override
  State<DocumentCreatePage> createState() => _DocumentCreatePageState();
}

class _DocumentCreatePageState extends State<DocumentCreatePage> {
  final TextEditingController titleController = TextEditingController();
  bool isLoading = false;

  Future<void> _createDocument() async {
    if (titleController.text.trim().isEmpty) return;

    setState(() => isLoading = true);
    try {
      final repo = getIt<DocumentRepository>();
      await repo.createDocument(titleController.text.trim(), widget.projectId);

      if (context.mounted) Navigator.pop(context); // 뒤로 가기
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('문서 생성 실패: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('문서 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: '문서 제목'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _createDocument,
              child: const Text('생성하기'),
            ),
          ],
        ),
      ),
    );
  }
}
