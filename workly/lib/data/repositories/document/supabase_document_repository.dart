import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workly/data/models/block.dart';
import 'package:workly/data/models/document.dart';
import 'package:workly/data/repositories/document/document_repository.dart';

class SupabaseDocumentRepository implements DocumentRepository {
  final _docTable = 'documents';
  final _blockTable = 'blocks';

  @override
  Future<Document> createDocument(String title, String projectId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception('로그인 필요');

    final response =
        await Supabase.instance.client
            .from(_docTable)
            .insert({
              'title': title,
              'project_id': projectId,
              'owner_id': user.id,
            })
            .select()
            .single();

    return Document.fromJson(response);
  }

  @override
  Future<Document?> getDocument(String id) async {
    final result =
        await Supabase.instance.client
            .from('documents')
            .select()
            .eq('id', id)
            .maybeSingle();

    if (result == null) return null;

    final blocksResult = await Supabase.instance.client
        .from('blocks')
        .select()
        .eq('document_id', id)
        .order('order', ascending: true);

    final blocks =
        (blocksResult as List).map((b) => Block.fromJson(b)).toList();

    return Document.fromJson(result).copyWith(blocks: blocks);
  }

  @override
  Future<void> updateDocument(Document document) async {
    await Supabase.instance.client
        .from(_docTable)
        .update(document.toJson())
        .eq('id', document.id);
  }

  @override
  Future<void> addBlock(String documentId, Block block) async {
    await Supabase.instance.client.from(_blockTable).insert({
      ...block.toJson(),
      'document_id': documentId,
    });
  }

  @override
  Future<void> updateBlock(String documentId, Block block) async {
    await Supabase.instance.client
        .from(_blockTable)
        .update(block.toJson())
        .eq('id', block.id)
        .eq('document_id', documentId);
  }

  @override
  Future<void> deleteBlock(String documentId, String blockId) async {
    await Supabase.instance.client
        .from(_blockTable)
        .delete()
        .eq('id', blockId)
        .eq('document_id', documentId);
  }

  @override
  Stream<List<Block>> watchBlocks(String documentId) {
    return Supabase.instance.client
        .from('block')
        .stream(primaryKey: ['id'])
        .eq('document_id', documentId)
        .order('created_at')
        .map((data) => data.map((b) => Block.fromJson(b)).toList());
  }
}
