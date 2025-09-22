import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import '../widgets/screen_title.dart';
import '../utils/theme.dart';

class PostWriteScreen extends StatefulWidget {
  final bool isEditMode;
  final String? postId;
  
  const PostWriteScreen({
    super.key,
    this.isEditMode = false,
    this.postId,
  });

  @override
  State<PostWriteScreen> createState() => _PostWriteScreenState();
}

class _PostWriteScreenState extends State<PostWriteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  List<PostBlockData> blocks = [];
  List<String> selectedTags = [];
  bool isSubmitting = false;
  
  // Available tags (mapped to backend tag IDs)
  final List<TagData> availableTags = [
    TagData(id: 1, name: 'Daily Life', emoji: '🏠'),
    TagData(id: 2, name: 'Campus Life', emoji: '🎓'),
    TagData(id: 3, name: 'Jobs', emoji: '💼'),
    TagData(id: 4, name: 'Food Spots', emoji: '🍜'),
    TagData(id: 5, name: 'SNU', emoji: '🏫'),
    TagData(id: 6, name: 'KU', emoji: '🏫'),
    TagData(id: 7, name: 'YU', emoji: '🏫'),
  ];

  @override
  void initState() {
    super.initState();
    
    if (widget.isEditMode && widget.postId != null) {
      // 편집 모드: 기존 게시글 데이터 로드
      _loadPostForEdit();
    } else {
      // 새 글 작성 모드: 빈 텍스트 블록 추가
      _addTextBlock();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    for (var block in blocks) {
      block.textController?.dispose();
    }
    super.dispose();
  }

  Future<void> _loadPostForEdit() async {
    try {
      final post = await PostService.getPostDetail(widget.postId!);
      
      // 제목 설정
      _titleController.text = post.title;
      
      // 태그 설정 (ID를 이름으로 변환)
      print('게시글에서 가져온 태그: ${post.tags}');
      selectedTags = post.tags.map((tagId) {
        print('태그 처리 중: $tagId (타입: ${tagId.runtimeType})');
        final tagData = availableTags.where((tag) => tag.id == tagId).firstOrNull;
        print('찾은 태그 데이터: $tagData');
        return tagData?.name ?? '';
      }).where((name) => name.isNotEmpty).toList();
      print('최종 선택된 태그: $selectedTags');
      
      blocks.clear();
      for (var block in post.blocks) {
        if (block.type == PostBlockType.paragraph) {
          final controller = TextEditingController(text: block.text ?? '');
          blocks.add(PostBlockData(
            type: PostBlockType.paragraph,
            textController: controller,
          ));
        } else if (block.type == PostBlockType.image) {
          blocks.add(PostBlockData(
            type: PostBlockType.image,
            imageUrl: block.imageUrl,
          ));
        }
      }
      
      if (blocks.isEmpty) {
        _addTextBlock();
      }
      
      setState(() {});
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load post: $e')),
        );
        Navigator.pop(context);
      }
    }
  }

  void _addTextBlock() {
    setState(() {
      blocks.add(PostBlockData(
        type: PostBlockType.paragraph,
        textController: TextEditingController(),
      ));
    });
  }

  void _addImageBlock() {
    final imageBlockCount = blocks.where((b) => b.type == PostBlockType.image).length;
    if (imageBlockCount >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 6 images allowed')),
      );
      return;
    }

    setState(() {
      blocks.add(PostBlockData(
        type: PostBlockType.image,
        imageUrl: 'https://via.placeholder.com/300x200', // Temporary image
      ));
    });
  }

  void _removeBlock(int index) {
    setState(() {
      blocks[index].textController?.dispose();
      blocks.removeAt(index);
      
      if (blocks.isEmpty) {
        _addTextBlock();
      }
    });
  }

  void _toggleTag(String tagName) {
    setState(() {
      if (selectedTags.contains(tagName)) {
        selectedTags.remove(tagName);
      } else {
        selectedTags.add(tagName);
      }
    });
  }

  bool get _canSubmit {
    return _titleController.text.trim().isNotEmpty && 
           blocks.any((block) => 
             block.type == PostBlockType.paragraph && 
             (block.textController?.text.trim().isNotEmpty ?? false)
           ) &&
           !isSubmitting;
  }

  Future<void> _submitPost() async {
    print('=== _submitPost 시작 ===');
    print('_canSubmit: $_canSubmit');
    
    if (!_canSubmit) {
      print('_canSubmit이 false이므로 종료');
      return;
    }

    final title = _titleController.text.trim();
    print('제목: "$title" (길이: ${title.length})');
    
    if (title.length > 60) {
      print('제목이 60자를 초과함');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title must be within 60 characters')),
      );
      return;
    }

    print('블록 개수: ${blocks.length}');
    if (blocks.length > 20) {
      print('블록이 20개를 초과함');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 20 blocks allowed')),
      );
      return;
    }

    print('선택된 태그: $selectedTags');
    
    setState(() {
      isSubmitting = true;
    });
    print('isSubmitting을 true로 설정');

    try {
      print('태그 이름을 ID로 변환 중...');
      final selectedTagIds = selectedTags
          .map((tagName) => availableTags.firstWhere((tag) => tag.name == tagName).id)
          .toList();
      print('선택된 태그 ID: $selectedTagIds');

      print('블록 데이터 준비 중...');
      final blockData = blocks.asMap().entries.map((entry) {
        final index = entry.key;
        final block = entry.value;
        
        final blockJson = {
          'idx': index,
          'type': block.type == PostBlockType.paragraph ? 'paragraph' : 'image',
          if (block.type == PostBlockType.paragraph)
            'text': block.textController?.text.trim() ?? '',
          if (block.type == PostBlockType.image)
            'image_url': block.imageUrl ?? '',
        };
        
        print('블록 $index: $blockJson');
        return blockJson;
      }).where((block) {
        if (block['type'] == 'paragraph') {
          final isEmpty = (block['text'] as String).isEmpty;
          if (isEmpty) {
            print('빈 텍스트 블록 제외: $block');
          }
          return !isEmpty;
        }
        return true;
      }).toList();
      
      print('최종 블록 데이터: $blockData');

      final postData = {
        'lang': 'en',
        'title': title,
        'tags': selectedTagIds,
        'blocks': blockData,
      };

      print('전송할 데이터: $postData');

      if (widget.isEditMode && widget.postId != null) {
        await PostService.updatePost(widget.postId!, postData);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post updated successfully!')),
          );
          Navigator.pop(context, true);
        }
      } else {//새 post 작성성
        print('새 글 작성 모드 - API 호출 시작');
        
        await PostService.createPost(postData);
        print('새 글 작성 API 호출 완료');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post created successfully!')),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      print('=== 에러 발생 ===');
      print('에러 타입: ${e.runtimeType}');
      print('에러 메시지: $e');
      if (e is Error) {
        print('스택 트레이스: ${e.stackTrace}');
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save post: $e')),
        );
      }
    } finally {
      print('=== finally 블록 실행 ===');
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
        print('isSubmitting을 false로 설정');
      }
      print('=== _submitPost 종료 ===');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ScreenTitle('Write'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _canSubmit ? _submitPost : null,
            child: isSubmitting 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Post',
                    style: TextStyle(
                      color: _canSubmit 
                          ? Theme.of(context).primaryColor 
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title input
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          child: TextField(
                            controller: _titleController,
                            focusNode: _focusNode,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Enter title here',
                              hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLength: 60,
                            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null, // Remove built-in counter
                            onChanged: (value) => setState(() {}),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_titleController.text.length}/60',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Tag selection
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableTags.map((tag) {
                        final isSelected = selectedTags.contains(tag.name);
                        return FilterChip(
                          label: Text('${tag.emoji} ${tag.name}'),
                          selected: isSelected,
                          onSelected: (selected) => _toggleTag(tag.name),
                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                          selectedColor: Theme.of(context).primaryColor,
                          showCheckmark: false, // Remove checkmark
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected 
                                ? Colors.white // White text on brand color background
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          side: BorderSide.none, // Remove border
                        );
                      }).toList(),
                    ),
                  ),
                  
                  // Content editor
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Unified content area (no visible block separation)
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(minHeight: 300),
                          child: Column(
                            children: blocks.asMap().entries.map((entry) {
                              final index = entry.key;
                              final block = entry.value;
                              
                              return Container(
                                margin: EdgeInsets.only(
                                  bottom: index == blocks.length - 1 ? 0 : 16,
                                ),
                                child: _buildBlock(block, index),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  _ToolbarButton(
                    icon: Icons.camera_alt,
                    tooltip: 'Add Image',
                    onPressed: _addImageBlock,
                  ),
                  const SizedBox(width: 16),
                  _ToolbarButton(
                    icon: Icons.text_fields,
                    tooltip: 'Add Text',
                    onPressed: _addTextBlock,
                  ),
                  const Spacer(),
                  Text(
                    'Blocks: ${blocks.length}/20',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlock(PostBlockData block, int index) {
    if (block.type == PostBlockType.paragraph) {
      // Use different hint text for first block
      final hintText = index == 0 
          ? 'Share your thoughts here...'
          : 'Continue writing here...';
      
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            child: TextField(
              controller: block.textController,
              decoration: InputDecoration.collapsed(
                hintText: hintText,
                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              ),
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
              maxLines: null,
              minLines: 3,
              onChanged: (value) => setState(() {}),
            ),
          ),
          // Delete button for multiple blocks
          if (blocks.length > 1)
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => _removeBlock(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
        ],
      );
    } else {
      return Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[50],
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
              image: block.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(block.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: block.imageUrl == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Image upload coming soon',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
          // Delete button
          if (blocks.length > 1)
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => _removeBlock(index),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      );
    }
  }
}

// Toolbar button widget
class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// Block data class
class PostBlockData {
  final PostBlockType type;
  final TextEditingController? textController;
  final String? imageUrl;

  PostBlockData({
    required this.type,
    this.textController,
    this.imageUrl,
  });
}

// Tag data class
class TagData {
  final int id;
  final String name;
  final String emoji;

  TagData({
    required this.id,
    required this.name,
    required this.emoji,
  });
}
