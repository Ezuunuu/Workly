part of 'document_cubit.dart';

enum DocumentStatus { init, loading, success, failed }

class DocumentState {
  DocumentState({this.status = DocumentStatus.init, this.currentDoc});

  final DocumentStatus status;
  final Document? currentDoc;

  DocumentState copyWith({DocumentStatus? status, Document? currentDoc}) {
    return DocumentState(
      status: status ?? this.status,
      currentDoc: currentDoc ?? this.currentDoc,
    );
  }
}
