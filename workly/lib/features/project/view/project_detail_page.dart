import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:workly/features/project/cubit/project_cubit.dart';
import 'package:workly/features/document/cubit/document_cubit.dart';
import 'package:workly/data/repositories/document/document_repository.dart';

class ProjectDetailPage extends StatelessWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.I<ProjectCubit>()..loadProjectById(projectId),
        ),
        BlocProvider(create: (_) => GetIt.I<DocumentCubit>()),
      ],
      child: _ProjectDetailView(),
    );
  }
}

class _ProjectDetailView extends StatefulWidget {
  const _ProjectDetailView({super.key});

  @override
  State<_ProjectDetailView> createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<_ProjectDetailView> {
  String selectedType = 'document';
  bool isAddingDocument = false;
  final TextEditingController docNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        if (state.status == ProjectStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final project = state.currentProject;
        if (project == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('프로젝트를 불러올 수 없습니다.')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(project.name)),
          body: Row(
            children: [
              // 사이드바
              Container(
                width: 260,
                color: Colors.grey.shade100,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      '📄 문서',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...project.documents.map(
                      (doc) => ListTile(
                        dense: true,
                        selected:
                            context.read<DocumentCubit>().state.currentDoc ==
                            doc,
                        title: Text(doc.title),
                        onTap: () async {
                          await context.read<DocumentCubit>().loadDocument(
                            doc.id,
                          );
                          setState(() => selectedType = 'document');
                        },
                      ),
                    ),
                    if (isAddingDocument)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: docNameController,
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: '문서 제목 입력',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted:
                                  (_) => _submitNewDocument(project.id),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () => _submitNewDocument(project.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                isAddingDocument = false;
                                docNameController.clear();
                              });
                            },
                          ),
                        ],
                      )
                    else
                      TextButton.icon(
                        onPressed:
                            () => setState(() => isAddingDocument = true),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('문서 추가'),
                      ),
                    const SizedBox(height: 24),

                    const Text(
                      '✅ 태스크',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...project.tasks.map(
                      (task) => ListTile(
                        dense: true,
                        title: Text(task.title),
                        trailing:
                            task.isDone
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                        onTap: () => setState(() => selectedType = 'task'),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: 태스크 생성
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('태스크 추가'),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      '🎨 화이트보드',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...project.whiteboards.map(
                      (wb) => ListTile(
                        dense: true,
                        title: Text(wb.name),
                        onTap:
                            () => setState(() => selectedType = 'whiteboard'),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: 화이트보드 생성
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('화이트보드 추가'),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              // 본문
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: _buildDetailView(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailView() {
    if (selectedType == 'document') {
      return BlocBuilder<DocumentCubit, DocumentState>(
        builder: (context, state) {
          if (state.status == DocumentStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.currentDoc == null) {
            return Center(
              child: TextButton.icon(
                onPressed: () {
                  // TODO: 블록 생성
                },
                icon: Icon(Icons.add, size: 18),
                label: Text('블록 추가'),
              ),
            );
          }

          final doc = state.currentDoc!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(doc.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('생성일: ${doc.createdAt.toIso8601String()}'),
            ],
          );
        },
      );
    } else if (selectedType == 'task') {
      return const Center(child: Text('태스크 상세 보기'));
    } else if (selectedType == 'whiteboard') {
      return const Center(child: Text('화이트보드 상세 보기'));
    } else {
      return const Center(child: Text('항목을 선택해주세요'));
    }
  }

  Future<void> _submitNewDocument(String projectId) async {
    final title = docNameController.text.trim();
    if (title.isEmpty) return;

    try {
      final newDoc = await GetIt.I<DocumentRepository>().createDocument(
        title,
        projectId,
      );
      context.read<ProjectCubit>().loadProjectById(projectId);
      context.read<DocumentCubit>().loadDocument(newDoc.id);

      setState(() {
        selectedType = 'document';
        isAddingDocument = false;
        docNameController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('문서 생성 실패: $e')));
    }
  }
}
