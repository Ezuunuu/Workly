import 'package:flutter/material.dart';

class ProjectDetailPage extends StatelessWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로젝트 상세')), // 향후 프로젝트 이름으로 대체
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('문서 추가'),
            onTap: () {
              /* Document 생성 로직 */
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_box),
            title: const Text('태스크 추가'),
            onTap: () {
              /* Task 생성 로직 */
            },
          ),
          ListTile(
            leading: const Icon(Icons.draw),
            title: const Text('화이트보드 추가'),
            onTap: () {
              /* Whiteboard 생성 로직 */
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('멤버 초대'),
            onTap: () {
              /* 초대 로직 */
            },
          ),
        ],
      ),
    );
  }
}
