import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:litewriter/models/chapter.dart';
import 'package:litewriter/viewmodels/chapter_viewmodel.dart';

class DistractionFreeEditorView extends StatefulWidget {
  final Chapter chapter;

  const DistractionFreeEditorView({super.key, required this.chapter});

  @override
  State<DistractionFreeEditorView> createState() => _DistractionFreeEditorViewState();
}

class _DistractionFreeEditorViewState extends State<DistractionFreeEditorView> {
  late TextEditingController _contentController;
  late ChapterViewModel _chapterViewModel;
  bool _isPreviewMode = false;
  bool _showWordCount = true;

  @override
  void initState() {
    super.initState();
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
    widget.chapter.content = _contentController.text;
    _chapterViewModel.updateChapter(widget.chapter);
  }

  @override
  void dispose() {
    _saveChapter(); // Save on exit
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Minimal header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      widget.chapter.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (_chapterViewModel.markdownEnabled)
                    IconButton(
                      icon: Icon(_isPreviewMode ? Icons.edit : Icons.preview),
                      onPressed: () {
                        setState(() {
                          _isPreviewMode = !_isPreviewMode;
                        });
                      },
                    ),
                  IconButton(
                    icon: Icon(_showWordCount ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showWordCount = !_showWordCount;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            // Content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildContentEditor(),
              ),
            ),
            
            // Word count (if enabled)
            if (_showWordCount)
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Words: ${_getWordCount()}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentEditor() {
    if (_chapterViewModel.markdownEnabled && _isPreviewMode) {
      return SingleChildScrollView(
        child: Markdown(
          data: _contentController.text,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(
              fontSize: 18,
              height: 1.6,
            ),
          ),
        ),
      );
    }

    return TextField(
      controller: _contentController,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        hintText: 'Start writing...',
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(0),
      ),
      style: const TextStyle(
        fontSize: 18,
        height: 1.6,
      ),
      textAlignVertical: TextAlignVertical.top,
      autofocus: true,
    );
  }

  int _getWordCount() {
    final text = _contentController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }
}

