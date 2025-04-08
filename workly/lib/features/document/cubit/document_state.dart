part of 'document_cubit.dart';

enum DocumentStatus { init, loading, success, failed }

class DocumentState {
  DocumentState({
    this.status = DocumentStatus.init,
    this.currentDoc,
    this.errorMessage,
  });

  final DocumentStatus status;
  final Document? currentDoc;
  final String? errorMessage;

  DocumentState copyWith({
    DocumentStatus? status,
    Document? currentDoc,
    String? errorMessage,
  }) {
    return DocumentState(
      status: status ?? this.status,
      currentDoc: currentDoc ?? this.currentDoc,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
