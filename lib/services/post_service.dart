import '../network/http.dart';
import '../config/endpoints.dart';
import '../models/api_response.dart';
import 'package:dio/dio.dart';
import '../models/feed.dart';
import '../models/hot_post.dart';
import '../models/post.dart';

class PostService {
  static int? _getTagId(String tagName) { //TODO: 태그를 한번에 모아서서
    const tagMap = {
      'Daily Life': 1,
      'Campus Life': 2,
      'Jobs': 3,
      'Food Spots': 4,
      'SNU': 5,
      'KU': 6,
      'YU': 7,
      // 공지사항 카테고리
      'Transportation': 8,
      'Convenience Store': 9,
      'Fraud Alert': 10,
    };
    return tagMap[tagName];
  }
  // GET /api/posts
  static Future<PostsResponse> getPosts({
    String? cursor,
    int limit = 10,
    String? q,
    String? tag,
    int? tagId,
    bool? isAnnouncement,
  }) async {
    int? finalTagId = tagId;
    if (tag != null && tag.isNotEmpty && finalTagId == null) {
      finalTagId = _getTagId(tag);
    }

    final queryParams = <String, dynamic>{
      'limit': limit,
      if (cursor != null) 'cursor': cursor,
      if (finalTagId != null) 'tagId': finalTagId
      else if (q != null && q.isNotEmpty) 'q': q,
      if (isAnnouncement != null) 'isAnnouncement': isAnnouncement,
    };

    final response = await dio.get(
      EP.posts,
      queryParameters: queryParams,
    );
    print('API 응답: ${response.data}');
    
    final apiData = response.data['data'];
    print('추출된 데이터: $apiData');
    
    return PostsResponse.fromJson(apiData);
  }

  // GET /api/posts/hot
  static Future<List<HotPost>> getHotPosts() async {
    final response = await dio.get(EP.postsHot);
    
    print('Hot Posts API 응답: ${response.data}');
    
    final apiData = response.data['data'] as List<dynamic>;
    print('Hot Posts 추출된 데이터: $apiData');
    
    return apiData.map((item) => HotPost.fromJson(item)).toList();
  }

  // GET /api/posts/{post_id}
  static Future<Post> getPostDetail(String postId, {String? currentUserId}) async {
    print('게시물 상세 API 호출: /api/posts/$postId, userId: $currentUserId');
    
    final headers = <String, dynamic>{};
    if (currentUserId != null) {
      headers['X-Temp-User-Id'] = currentUserId;
    }
    
    final response = await dio.get(
      EP.postDetail(postId),
      options: Options(headers: headers),
    );
    
    print('게시물 상세 API 응답: ${response.data}');
    
    final apiData = response.data['data'];
    print('게시물 상세 추출된 데이터: $apiData');
    
    return Post.fromJson(apiData);
  }

  // PUT /api/posts/{post_id}
  static Future<void> updatePost(String postId, String currentUserId, Map<String, dynamic> updateData) async {
    print('게시물 수정 API 호출: /api/posts/$postId, userId: $currentUserId');
    print('수정 데이터: $updateData');
    
    final response = await dio.put(
      EP.postDetail(postId),
      data: updateData,
      options: Options(headers: {
        'X-Temp-User-Id': currentUserId,
      }),
    );
    
    print('게시물 수정 API 응답: ${response.data}');
  }
  
  // DELETE /api/posts/{post_id}
  static Future<void> deletePost(String postId, String currentUserId) async {
    print('게시물 삭제 API 호출: /api/posts/$postId, userId: $currentUserId');
    
    final response = await dio.delete(
      EP.postDetail(postId),
      options: Options(headers: {
        'X-Temp-User-Id': currentUserId,
      }),
    );
    
    print('게시물 삭제 API 응답: ${response.data}');
  }

  // POST /api/posts
  static Future<void> createPost(String currentUserId, Map<String, dynamic> postData) async {
    print('게시물 생성 API 호출: $postData');
    print('사용자 ID: $currentUserId');
    
    final response = await dio.post(
      EP.posts,
      data: postData,
      options: Options(headers: {
        'X-Temp-User-Id': currentUserId,
      }),
    );
    
    print('게시물 생성 API 응답: ${response.data}');
    
    final apiData = response.data['data'];
    print('게시물 생성 추출된 데이터: $apiData');
  }
}
