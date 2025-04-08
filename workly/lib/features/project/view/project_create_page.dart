import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workly/features/project/cubit/project_cubit.dart';

class ProjectCreatePage extends StatefulWidget {
  const ProjectCreatePage({super.key});

  @override
  State<ProjectCreatePage> createState() => _ProjectCreatePageState();
}

class _ProjectCreatePageState extends State<ProjectCreatePage> {
  final TextEditingController nameController = TextEditingController();
  bool isSubmitting = false;

  Future<void> _createProject() async {
    setState(() => isSubmitting = true);

    final cubit = context.read<ProjectCubit>();
    await cubit.addProject(nameController.text.trim());

    if (!mounted) return;

    final state = cubit.state;
    if (state.status == ProjectStatus.success) {
      Navigator.pop(context, true);
    } else if (state.status == ProjectStatus.failure) {
      final error = state.errorMessage ?? '알 수 없는 오류';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('프로젝트 생성 실패: $error')));
    }

    setState(() => isSubmitting = false);
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSubmitting ? null : _createProject,
              child:
                  isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('생성하기'),
            ),
          ],
        ),
      ),
    );
  }
}
