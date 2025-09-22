import 'package:flutter/foundation.dart';

enum PostBlockType { paragraph, image }

class PostBlock {
  final int index;                 // unique per post
  final PostBlockType type;        // paragraph | image
  final String? text;              // when paragraph
  final String? imageUrl;          // when image

  PostBlock({
    required this.index,
    required this.type,
    this.text,
    this.imageUrl,
  });

  factory PostBlock.fromJson(Map<String, dynamic> j) {
    return PostBlock(
      index: j['idx'] as int, // 백엔드에서는 'idx'로 응답
      type: (j['type'] == 'image') ? PostBlockType.image : PostBlockType.paragraph, // 소문자로 변경
      text: j['text'] as String?,
      imageUrl: j['image_url'] as String?,
    );
  }
}

class Post {
  final String id;
  final String? authorId;          // nullable if deleted
  final String? authorName;        // nullable if deleted
  final String? authorAvatarUrl;   // nullable
  final String lang;               // 'en' (for now)
  final String title;              // 1~20 chars
  final String content;            // 1~1000 chars (legacy/summary)
  final List<int> tags;         // e.g., [1, 2] - tag IDs
  final String schoolCode;         // SNU/KU/YU...
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String contentText;        // merged plain text
  final List<PostBlock> blocks;    // ordered by index
  final bool isOwner;              // true if current user is the owner

  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.lang,
    required this.title,
    required this.content,
    required this.tags,
    required this.schoolCode,
    required this.createdAt,
    this.updatedAt,
    required this.contentText,
    required this.blocks,
    required this.isOwner,
  });

  factory Post.fromJson(Map<String, dynamic> j) {
    return Post(
      id: j['post_id'].toString(),
      authorId: j['author']?['user_id']?.toString(), // int를 String으로 변환
      authorName: j['author']?['username'] as String?,
      authorAvatarUrl: null, // API에 avatar_url 없음
      lang: j['lang'] as String,
      title: j['title'] as String,
      content: j['content_text'] as String? ?? '',
      tags: (j['tags'] as List? ?? [])
          .map((e) => e is int ? e : int.tryParse('$e') ?? -1)
          .where((e) => e > 0) // 0/-1 같은 비정상 값 거르기
          .toList(),
      schoolCode: '', // API에 school_code 없음
      createdAt: DateTime.parse(j['created_at'] as String),
      updatedAt: j['updated_at'] != null ? DateTime.parse(j['updated_at']) : null,
      contentText: j['content_text'] as String? ?? '',
      blocks: (j['blocks'] as List? ?? [])
          .map((b) => PostBlock.fromJson(b as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.index.compareTo(b.index)),
      isOwner: j['is_owner'] as bool? ?? false,
    );
  }
}
