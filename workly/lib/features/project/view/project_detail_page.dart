import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:workly/data/models/block.dart';
import 'package:workly/data/models/block_content/block_content.dart';
import 'package:workly/data/models/block_content/checkbox_content.dart';
import 'package:workly/data/models/block_content/image_content.dart';
import 'package:workly/data/models/block_content/table_content.dart';
import 'package:workly/data/models/block_content/text_content.dart';
import 'package:workly/features/project/cubit/project_cubit.dart';
import 'package:workly/features/document/cubit/document_cubit.dart';
import 'package:workly/data/repositories/document/document_repository.dart';
import 'package:uuid/uuid.dart';

class ProjectDetailPage extends StatelessWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.I<ProjectCubit>()..loadProjectById(projectId),
        ),
        BlocProvider(create: (_) => GetIt.I<DocumentCubit>()),
      ],
      child: _ProjectDetailView(),
    );
  }
}

class _ProjectDetailView extends StatefulWidget {
  const _ProjectDetailView();

  @override
  State<_ProjectDetailView> createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<_ProjectDetailView> {
  String selectedType = 'document';
  bool isAddingDocument = false;
  final TextEditingController docNameController = TextEditingController();

  final GlobalKey _canvasKey = GlobalKey();
  String? draggingBlockId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        if (state.status == ProjectStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final project = state.currentProject;
        if (project == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('프로젝트를 불러올 수 없습니다.')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(project.name)),
          body: Row(
            children: [
              // 사이드바
              Container(
                width: 260,
                color: Colors.grey.shade100,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      '📄 문서',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...project.documents.map(
                      (doc) => ListTile(
                        dense: true,
                        selected:
                            context.read<DocumentCubit>().state.currentDoc ==
                            doc,
                        title: Text(doc.title),
                        onTap: () async {
                          await context.read<DocumentCubit>().loadDocument(
                            doc.id,
                          );
                          setState(() => selectedType = 'document');
                        },
                      ),
                    ),
                    if (isAddingDocument)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: docNameController,
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: '문서 제목 입력',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted:
                                  (_) => _submitNewDocument(project.id),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () => _submitNewDocument(project.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                isAddingDocument = false;
                                docNameController.clear();
                              });
                            },
                          ),
                        ],
                      )
                    else
                      TextButton.icon(
                        onPressed:
                            () => setState(() => isAddingDocument = true),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('문서 추가'),
                      ),
                    const SizedBox(height: 24),

                    const Text(
                      '✅ 태스크',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...project.tasks.map(
                      (task) => ListTile(
                        dense: true,
                        title: Text(task.title),
                        trailing:
                            task.isDone
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                        onTap: () => setState(() => selectedType = 'task'),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: 태스크 생성
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('태스크 추가'),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      '🎨 화이트보드',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...project.whiteboards.map(
                      (wb) => ListTile(
                        dense: true,
                        title: Text(wb.name),
                        onTap:
                            () => setState(() => selectedType = 'whiteboard'),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: 화이트보드 생성
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('화이트보드 추가'),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              // 본문
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: _buildDetailView(),
                ),
              ),
            ],
          ),
          floatingActionButton: Builder(
            builder: (buttonContext) {
              return FloatingActionButton(
                onPressed: () => _showBlockMenu(buttonContext),
                child: const Icon(Icons.add),
              );
            },
          ),
        );
      },
    );
  }

  void _showBlockMenu(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy - (56.0 * 4 + 8),
        offset.dx + size.width,
        offset.dy,
      ),
      items: [
        PopupMenuItem<BlockType>(
          value: BlockType.text,
          child: ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('텍스트 블록'),
          ),
        ),
        PopupMenuItem<BlockType>(
          value: BlockType.image,
          child: ListTile(
            leading: const Icon(Icons.image),
            title: const Text('이미지 블록'),
          ),
        ),
        PopupMenuItem<BlockType>(
          value: BlockType.checkbox,
          child: ListTile(
            leading: const Icon(Icons.check_box),
            title: const Text('체크박스 블록'),
          ),
        ),
        PopupMenuItem<BlockType>(
          value: BlockType.table,
          child: ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('표 블록'),
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _addBlock(value);
      }
    });
  }

  Future<void> _addBlock(BlockType blockType) async {
    final block = Block(
      id: Uuid().v4(),
      type: blockType,
      content: BlockContent.create(blockType), // BlockContent 생성
      order: DateTime.now().millisecondsSinceEpoch,
      position: Offset(0, 0),
      size: Size(100, 50),
    );
    await context.read<DocumentCubit>().addBlock(block);

    setState(() {
      draggingBlockId = null;
    });
  }

  Widget _buildTable(List<List<String>> data) {
    return SizedBox(
      width: 300,
      child: Table(
        border: TableBorder.all(),
        children:
            data.map((row) {
              return TableRow(
                children:
                    row
                        .map(
                          (cell) => Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(cell),
                          ),
                        )
                        .toList(),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildBlockWidget(Block block) {
    switch (block.type) {
      case BlockType.text:
        final content = block.content as TextContent;
        return SizedBox(
          width: 300,
          child: ListTile(
            leading: const Icon(Icons.text_fields),
            title: Text(content.text),
          ),
        );
      case BlockType.image:
        final content = block.content as ImageContent;
        return SizedBox(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Image.network(content.url),
          ),
        );
      case BlockType.checkbox:
        final content = block.content as CheckboxContent;
        return SizedBox(
          width: 300,
          child: CheckboxListTile(
            title: Text(content.label),
            value: content.checked,
            onChanged: (val) {},
          ),
        );
      case BlockType.table:
        final content = block.content as TableContent;
        return _buildTable(content.rows);
    }
  }

  Widget _buildBorderWrapper({required bool isActive, required Widget child}) {
    if (isActive) {
      return DottedBorder(
        color: Colors.blueAccent,
        strokeWidth: 2,
        dashPattern: [6, 3],
        borderType: BorderType.RRect,
        radius: const Radius.circular(4),
        child: child,
      );
    }
    return child;
  }

  Widget _buildDraggableBlock(Block block) {
    final isDragging = draggingBlockId != null && draggingBlockId == block.id;
    return Positioned(
      left: block.position.dx,
      top: block.position.dy,
      child: LongPressDraggable<Block>(
        data: block,
        feedback: Material(
          color: Colors.transparent,
          child: _buildBorderWrapper(
            isActive: true,
            child: _buildBlockWidget(block),
          ),
        ),
        childWhenDragging: const SizedBox.shrink(),
        onDragStarted: () {
          setState(() => draggingBlockId = block.id);
        },
        onDragEnd: (details) async {
          final renderBox = _canvasKey.currentContext?.findRenderObject();
          if (renderBox is! RenderBox) return;

          final localOffset = renderBox.globalToLocal(details.offset);
          final size = renderBox.size;

          final dx = localOffset.dx.clamp(0.0, size.width - block.size.width);
          final dy = localOffset.dy.clamp(0.0, size.height - block.size.height);

          final safeOffset = Offset(dx, dy);

          final updated = block.copyWith(position: safeOffset);
          draggingBlockId = null;
          context.read<DocumentCubit>().updateBlock(updated);
        },
        child: _buildBorderWrapper(
          isActive: isDragging,
          child: _buildBlockWidget(block),
        ),
      ),
    );
  }

  Widget _buildDetailView() {
    if (selectedType == 'document') {
      return BlocBuilder<DocumentCubit, DocumentState>(
        builder: (context, state) {
          if (state.status == DocumentStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final doc = state.currentDoc;
          if (doc == null) {
            return const Center(child: Text('빈 문서'));
          }

          return Stack(
            key: _canvasKey,
            children: [
              Positioned.fill(child: Container(color: Colors.white)),
              ...doc.blocks.map(_buildDraggableBlock),
              if (draggingBlockId != null)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: DragTarget<Block>(
                    onWillAcceptWithDetails: (block) => true,
                    onAcceptWithDetails: (details) async {
                      await context.read<DocumentCubit>().deleteBlock(
                        details.data.id!,
                      );
                      setState(() => draggingBlockId = null);
                    },
                    builder: (context, candidateData, rejectedData) {
                      final isHovering = candidateData.isNotEmpty;
                      return Container(
                        height: 100,
                        color:
                            isHovering
                                ? Colors.red.withValues(alpha: .8)
                                : Colors.red.withValues(alpha: .5),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.delete, color: Colors.white, size: 30),
                            SizedBox(height: 4),
                            Text(
                              '여기로 드래그해서 삭제',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      );
    } else if (selectedType == 'task') {
      return const Center(child: Text('태스크 상세 보기'));
    } else if (selectedType == 'whiteboard') {
      return const Center(child: Text('화이트보드 상세 보기'));
    } else {
      return const Center(child: Text('항목을 선택해주세요'));
    }
  }

  Future<void> _submitNewDocument(String projectId) async {
    final title = docNameController.text.trim();
    if (title.isEmpty) return;

    try {
      final newDoc = await GetIt.I<DocumentRepository>().createDocument(
        title,
        projectId,
      );
      context.read<ProjectCubit>().loadProjectById(projectId);
      context.read<DocumentCubit>().loadDocument(newDoc.id);

      setState(() {
        selectedType = 'document';
        isAddingDocument = false;
        docNameController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('문서 생성 실패: $e')));
    }
  }
}
