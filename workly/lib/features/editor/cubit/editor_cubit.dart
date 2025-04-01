import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workly/data/repositories/document_repository.dart';

part 'editor_state.dart';

class EditorCubit extends Cubit<EditorState> {
  EditorCubit({required this.documentRepository}): super(EditorState());
  final DocumentRepository documentRepository;
}