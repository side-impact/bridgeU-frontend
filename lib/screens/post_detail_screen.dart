import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/post_block_view.dart';
import '../services/post_service.dart';
import '../utils/tag_labels.dart';
import 'post_write_screen.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final isDeleted = post.authorId == null;
    final displayName = isDeleted ? 'Deleted user' : (post.authorName ?? 'User');
    final avatarUrl = isDeleted ? null : post.authorAvatarUrl;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FEED'),
        actions: post.isOwner ? [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _onEditPressed(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _onDeletePressed(context),
          ),
        ] : null,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header(post: post)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black12,
                    backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: (avatarUrl == null || avatarUrl.isEmpty)
                        ? const Icon(Icons.person, color: Colors.white70)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(displayName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(_fmtDate(post.createdAt),
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: post.blocks.isNotEmpty
                ? SliverList.builder(
                    itemCount: post.blocks.length,
                    itemBuilder: (context, i) => PostBlockView(block: post.blocks[i]),
                  )
                : SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SelectableText(
                        post.contentText.isNotEmpty ? post.contentText : post.content,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  void _onEditPressed(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostWriteScreen(
          isEditMode: true,
          postId: post.id,
        ),
      ),
    );
    
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post updated successfully.')),
      );
      Navigator.pop(context, true);
    }
  }

  void _onDeletePressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?\nDeleted posts cannot be recovered.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deletePost(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePost(BuildContext context) async {
    try {
      await PostService.deletePost(post.id);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post deleted successfully.')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred while deleting: $e')),
        );
      }
    }
  }

  String _fmtDate(DateTime dt) {
    // yyyy.MM.dd HH:mm
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y.$m.$d $hh:$mm';
  }
}

class _Header extends StatelessWidget {
  final Post post;
  const _Header({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: post.tags.map((id) => _TagChip(tag: id)).toList(),
            ),
          const SizedBox(height: 10),
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final int tag;
  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        TagLabels.of(tag),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
