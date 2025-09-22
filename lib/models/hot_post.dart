class HotPost {
  final int postId;
  final List<int> tags;
  final String title;
  final int viewCount;

  HotPost({
    required this.postId,
    required this.tags,
    required this.title,
    required this.viewCount,
  });

  factory HotPost.fromJson(Map<String, dynamic> json) {
    return HotPost(
      postId: (json['post_id'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).cast<int>(),
      title: json['title'] as String,
      viewCount: (json['view_count'] as num).toInt(),
    );
  }
}
