import 'feed.dart';

class PostsResponse {
  final List<Feed> items;
  final String? nextCursor;
  final int limit;
  final bool hasMore;

  PostsResponse({
    required this.items,
    this.nextCursor,
    required this.limit,
    required this.hasMore,
  });

  factory PostsResponse.fromJson(Map<String, dynamic> json) {
    return PostsResponse(
      items: (json['items'] as List<dynamic>)
          .map((item) => Feed.fromJson(item))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
      limit: json['limit'] as int,
      hasMore: json['has_more'] as bool,
    );
  }
}
