import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workly/data/models/block.dart';
import 'package:workly/data/models/document.dart';
import 'package:workly/data/repositories/document/document_repository.dart';

class FirebaseDocumentRepository implements DocumentRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Document> createDocument(String title, String projectId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('로그인 필요');

    final ref = await _firestore.collection('documents').add({
      'title': title,
      'projectId': projectId,
      'ownerId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'blocks': [],
    });

    final snap = await ref.get();
    return Document.fromJson({'id': ref.id, ...snap.data()!});
  }

  @override
  Future<Document?> getDocument(String documentId) async {
    final snap = await _firestore.collection('documents').doc(documentId).get();
    if (!snap.exists) return null;

    return Document.fromJson({'id': snap.id, ...snap.data()!});
  }

  @override
  Future<void> updateDocument(Document document) async {
    await _firestore
        .collection('documents')
        .doc(document.id)
        .set(document.toJson());
  }

  @override
  Future<void> addBlock(String documentId, Block block) async {
    final ref = _firestore.collection('documents').doc(documentId);
    await ref.update({
      'blocks': FieldValue.arrayUnion([block.toJson()]),
    });
  }

  @override
  Future<void> updateBlock(String documentId, Block block) async {
    final doc = await getDocument(documentId);
    if (doc == null) return;

    final updated =
        doc.blocks
            .map((b) => b.id == block.id ? block : b)
            .map((b) => b.toJson())
            .toList();

    await _firestore.collection('documents').doc(documentId).update({
      'blocks': updated,
    });
  }

  @override
  Future<void> deleteBlock(String documentId, String blockId) async {
    final doc = await getDocument(documentId);
    if (doc == null) return;

    final updated =
        doc.blocks
            .where((b) => b.id != blockId)
            .map((b) => b.toJson())
            .toList();

    await _firestore.collection('documents').doc(documentId).update({
      'blocks': updated,
    });
  }

  @override
  Stream<List<Block>> watchBlocks(String documentId) {
    return _firestore.collection('documents').doc(documentId).snapshots().map((
      doc,
    ) {
      final data = doc.data();
      if (data == null) return <Block>[];
      return (data['blocks'] as List).map((b) => Block.fromJson(b)).toList();
    });
  }
}
