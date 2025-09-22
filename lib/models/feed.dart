import 'author.dart';

class Feed {
  final int postId;
  final List<int> tags;
  final String title;
  final String snippet;
  final String? firstImageUrl;
  final String createdAt;
  final int viewCount;
  final Author? author;
  final bool isAnnouncement;

  Feed({
    required this.postId,
    required this.tags,
    required this.title,
    required this.snippet,
    this.firstImageUrl,
    required this.createdAt,
    required this.viewCount,
    this.author,
    this.isAnnouncement = false,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      postId: (json['post_id'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).cast<int>(),
      title: json['title'] as String,
      snippet: json['snippet'] as String,
      firstImageUrl: json['first_image_url'] as String?,
      createdAt: json['created_at'] as String,
      viewCount: (json['view_count'] as num).toInt(),
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
    );
  }

  String get id => postId.toString();
  String get body => snippet;
  List<String> get images => firstImageUrl != null ? [firstImageUrl!] : [];
  int get views => viewCount;
}