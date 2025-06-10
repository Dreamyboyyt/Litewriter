import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:litewriter/models/chapter.dart';
import 'package:litewriter/viewmodels/chapter_viewmodel.dart';
import 'package:litewriter/views/distraction_free_editor_view.dart';

class ChapterEditorView extends StatefulWidget {
  final Chapter chapter;

  const ChapterEditorView({super.key, required this.chapter});

  @override
  State<ChapterEditorView> createState() => _ChapterEditorViewState();
}

class _ChapterEditorViewState extends State<ChapterEditorView> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late ChapterViewModel _chapterViewModel;
  bool _isPreviewMode = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.chapter.title);
    _contentController = TextEditingController(text: widget.chapter.content);
    _chapterViewModel = Provider.of<ChapterViewModel>(context, listen: false);
    
    // Auto-save every 30 seconds
    _startAutoSave();
  }

  void _startAutoSave() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _saveChapter();
        _startAutoSave();
      }
    });
  }

  void _saveChapter() {
    widget.chapter.title = _titleController.text;
    widget.chapter.content = _contentController.text;
    _chapterViewModel.updateChapter(widget.chapter);
  }

  @override
  void dispose() {
    _saveChapter(); // Save on exit
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter Editor'),
        actions: [
          Consumer<ChapterViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                icon: Icon(
                  viewModel.markdownEnabled ? Icons.code : Icons.text_fields,
                ),
                onPressed: viewModel.toggleMarkdown,
                tooltip: 'Toggle Markdown',
              );
            },
          ),
          if (_chapterViewModel.markdownEnabled)
            IconButton(
              icon: Icon(_isPreviewMode ? Icons.edit : Icons.preview),
              onPressed: () {
                setState(() {
                  _isPreviewMode = !_isPreviewMode;
                });
              },
              tooltip: _isPreviewMode ? 'Edit Mode' : 'Preview Mode',
            ),
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: _chapterViewModel,
                    child: DistractionFreeEditorView(chapter: widget.chapter),
                  ),
                ),
              );
            },
            tooltip: 'Distraction-free Mode',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChapter,
            tooltip: 'Save',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Chapter Title',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildContentEditor(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Words: ${_getWordCount()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Characters: ${_contentController.text.length}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentEditor() {
    if (_chapterViewModel.markdownEnabled && _isPreviewMode) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Markdown(
            data: _contentController.text,
            selectable: true,
          ),
        ),
      );
    }

    return TextField(
      controller: _contentController,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        hintText: 'Start writing your chapter...',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(16),
      ),
      style: const TextStyle(
        fontSize: 16,
        height: 1.5,
      ),
      textAlignVertical: TextAlignVertical.top,
    );
  }

  int _getWordCount() {
    final text = _contentController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }
}

