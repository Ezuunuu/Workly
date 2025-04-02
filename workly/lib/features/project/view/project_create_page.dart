import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:workly/data/repositories/project/project_repository.dart';

class ProjectCreatePage extends StatefulWidget {
  const ProjectCreatePage({super.key});

  @override
  State<ProjectCreatePage> createState() => _ProjectCreatePageState();
}

class _ProjectCreatePageState extends State<ProjectCreatePage> {
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  final projectRepository = GetIt.I<ProjectRepository>();

  Future<void> _createProject() async {
    setState(() => isLoading = true);
    try {
      await projectRepository.createProject(nameController.text.trim());
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => errorMessage = '생성 실패: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('새 프로젝트 만들기')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('프로젝트 이름', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _createProject,
              child:
                  isLoading
                      ? const CircularProgressIndicator()
                      : const Text('생성하기'),
            ),
          ],
        ),
      ),
    );
  }
}
