import 'package:workly/data/models/block.dart';
import 'package:workly/data/models/document.dart';

abstract class DocumentRepository {
  Future<Document> createDocument(String title, String projectId);
  Future<Document?> getDocument(String documentId);
  Future<void> updateDocument(Document document);

  Future<void> addBlock(String documentId, Block block);
  Future<void> updateBlock(String documentId, Block block);
  Future<void> deleteBlock(String documentId, String blockId);
  Stream<List<Block>> watchBlocks(String documentId);
}
