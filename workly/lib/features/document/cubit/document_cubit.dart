import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workly/data/models/block.dart';
import 'package:workly/data/models/document.dart';
import 'package:workly/data/repositories/document/document_repository.dart';

part 'document_state.dart';

class DocumentCubit extends Cubit<DocumentState> {
  DocumentCubit({required this.repository}) : super(DocumentState());

  final DocumentRepository repository;
  StreamSubscription<List<Block>>? _blockSubscription;

  Future<void> loadDocument(String id) async {
    emit(state.copyWith(status: DocumentStatus.loading));
    try {
      final doc = await repository.getDocument(id);
      emit(state.copyWith(status: DocumentStatus.success, currentDoc: doc));
    } catch (e) {
      emit(
        state.copyWith(
          status: DocumentStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void updateTitle(String title) {
    final doc = state.currentDoc;
    if (doc != null) {
      emit(state.copyWith(currentDoc: doc.copyWith(title: title)));
    }
  }

  Future<void> updateBlocks(List<Block> newBlocks) async {
    final current = state.currentDoc;
    if (current == null) return;

    final updated = current.copyWith(blocks: newBlocks);

    emit(state.copyWith(currentDoc: updated, status: DocumentStatus.loading));

    try {
      for (final block in newBlocks) {
        await repository.updateBlock(current.id, block);
      }

      emit(state.copyWith(currentDoc: updated, status: DocumentStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: DocumentStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addBlock(Block block) async {
    final current = state.currentDoc;
    if (current == null) return;

    final updatedBlocks = [...current.blocks, block];
    final updated = current.copyWith(blocks: updatedBlocks);

    emit(state.copyWith(currentDoc: updated, status: DocumentStatus.loading));

    try {
      await repository.addBlock(current.id, block);

      emit(state.copyWith(currentDoc: updated, status: DocumentStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: DocumentStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteBlock(String blockId) async {
    final current = state.currentDoc;
    if (current == null) return;

    final updatedBlocks =
        current.blocks.where((block) => block.id != blockId).toList();

    final updated = current.copyWith(blocks: updatedBlocks);

    emit(state.copyWith(currentDoc: updated, status: DocumentStatus.loading));

    try {
      await repository.deleteBlock(current.id, blockId);

      emit(state.copyWith(currentDoc: updated, status: DocumentStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: DocumentStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void startWatchingBlocks(String documentId) {
    _blockSubscription?.cancel(); // 기존 구독 해제

    _blockSubscription = repository.watchBlocks(documentId).listen((blocks) {
      final current = state.currentDoc;
      if (current != null) {
        emit(
          state.copyWith(
            currentDoc: current.copyWith(blocks: blocks),
            status: DocumentStatus.success,
          ),
        );
      }
    });
  }

  Future<void> updateBlock(Block updatedBlock) async {
    final current = state.currentDoc;
    if (current == null) return;

    final newBlocks =
        current.blocks.map((b) {
          return b.id == updatedBlock.id ? updatedBlock : b;
        }).toList();

    final updatedDoc = current.copyWith(blocks: newBlocks);
    emit(
      state.copyWith(currentDoc: updatedDoc, status: DocumentStatus.loading),
    );

    try {
      await repository.updateBlock(current.id, updatedBlock);
      emit(state.copyWith(status: DocumentStatus.success));
    } catch (_) {
      emit(state.copyWith(status: DocumentStatus.failed));
    }
  }

  @override
  Future<void> close() {
    _blockSubscription?.cancel();
    return super.close();
  }
}
