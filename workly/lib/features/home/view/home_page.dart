import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:workly/data/auth/authentication_repository.dart';
import 'package:workly/data/repositories/project/project_repository.dart';
import 'package:workly/features/auth/view/login_page.dart';
import 'package:workly/features/project/view/project_create_page.dart';
import 'package:workly/features/project/view/project_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> projects = [];
  bool isLoading = true;
  final projectRepository = GetIt.I<ProjectRepository>();

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final result = await projectRepository.loadProjects();
    setState(() {
      projects = result;
      isLoading = false;
    });
  }

  Future<void> _navigateToCreatePage() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProjectCreatePage()),
    );
    if (created == true) {
      _loadProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로젝트'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authRepo = GetIt.I<AuthenticationRepository>();
              await authRepo.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                builder: (context, constraints) {
                  const cardWidth = 160.0;
                  final crossAxisCount =
                      (constraints.maxWidth / cardWidth).floor();

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: projects.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount.clamp(1, 6), // 최소 1, 최대 6개
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 5 / 4,
                    ),
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return Material(
                        color: Colors.transparent, // 카드 배경과 겹치지 않게
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ProjectDetailPage(
                                      projectId: project['id'],
                                    ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project['name'] ?? '제목 없음',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Text(
                                    project['created_at']?.toString().substring(
                                          0,
                                          10,
                                        ) ??
                                        '',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
