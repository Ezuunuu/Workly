import 'package:workly/data/repositories/document_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workly/data/models/block.dart';
import 'package:workly/data/models/document.dart';

class FirebaseRepository implements DocumentRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addBlock(String documentId, Block block) {
    // TODO: implement addBlock
    throw UnimplementedError();
  }

  @override
  Future<Document> createDocument(String title, String ownerId) {
    // TODO: implement createDocument
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBlock(String documentId, String blockId) {
    // TODO: implement deleteBlock
    throw UnimplementedError();
  }

  @override
  Future<Document?> getDocument(String documentId) {
    // TODO: implement getDocument
    throw UnimplementedError();
  }

  @override
  Future<void> updateBlock(String documentId, Block block) {
    // TODO: implement updateBlock
    throw UnimplementedError();
  }

  @override
  Future<void> updateDocument(Document document) {
    // TODO: implement updateDocument
    throw UnimplementedError();
  }

  @override
  Stream<List<Block>> watchBlocks(String documentId) {
    // TODO: implement watchBlocks
    throw UnimplementedError();
  }
}
