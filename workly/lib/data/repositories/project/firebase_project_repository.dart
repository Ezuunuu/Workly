import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workly/data/repositories/project/project_repository.dart';

class FirebaseProjectRepository implements ProjectRepository {
  @override
  Future<void> createProject(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('로그인된 사용자가 없습니다.');

    await FirebaseFirestore.instance.collection('projects').add({
      'name': name,
      'owner_id': user.uid,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<Map<String, dynamic>>> loadProjects() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final result =
        await FirebaseFirestore.instance
            .collection('projects')
            .where('owner_id', isEqualTo: user.uid)
            .orderBy('created_at')
            .get();

    return result.docs.map((doc) => doc.data()).toList();
  }
}
