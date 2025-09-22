import 'package:flutter/material.dart';
import '../widgets/navigator.dart';
import '../models/feed.dart';
import '../models/post.dart';
import '../models/hot_post.dart';
import '../models/api_response.dart';
import '../widgets/feed_card.dart';
import '../widgets/feed_preview.dart';
import '../widgets/screen_title.dart';
import '../services/post_service.dart';
import 'post_detail_screen.dart';
import 'post_write_screen.dart';
import 'notice_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final ScrollController _listCtrl = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();
  
  bool isLoadingMore = false;
  bool isInitialLoading = true;
  List<Feed> feeds = [];
  List<HotPost> hotPosts = [];
  String? nextCursor;
  bool hasMore = true;
  String? currentSearchQuery;
  String? currentTag;

  @override
  void initState() {
    super.initState();
    _loadInitial();
    _listCtrl.addListener(_onScroll);
  }

  Future<void> _loadInitial() async {
    try {
      setState(() {
        isInitialLoading = true;
        feeds.clear();
        nextCursor = null;
        hasMore = true;
      });

      // Hot posts와 일반 posts를 순차적으로 로드 (디버깅용)
      print('Hot Posts 호출 시작...');
      final hotPostsResult = await PostService.getHotPosts();
      print('Hot Posts 호출 완료: ${hotPostsResult.length}개');
      
      print('일반 Posts 호출 시작...');
      final postsResult = await PostService.getPosts(
        q: currentSearchQuery,
        tag: currentTag,
      );
      print('일반 Posts 호출 완료: ${postsResult.items.length}개');

      setState(() {
        hotPosts = hotPostsResult;
        feeds = postsResult.items;
        nextCursor = postsResult.nextCursor;
        hasMore = postsResult.hasMore;
        isInitialLoading = false;
      });
      } catch (e) {
        setState(() {
          isInitialLoading = false;
        });
        print('API 호출 실패: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load data: $e')),
          );
        }
      }
  }

  void _onScroll() {
    if (_listCtrl.position.pixels >=
            _listCtrl.position.maxScrollExtent - 200 &&
        !isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (!hasMore || nextCursor == null) return;
    
    try {
      setState(() => isLoadingMore = true);
      
      final response = await PostService.getPosts(
        cursor: nextCursor,
        q: currentSearchQuery,
        tag: currentTag,
      );

      setState(() {
        feeds.addAll(response.items);
        nextCursor = response.nextCursor;
        hasMore = response.hasMore;
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() => isLoadingMore = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load more data: $e')),
        );
      }
    }
  }

  Future<void> _onSearch(String query) async {
    currentSearchQuery = query.isEmpty ? null : query;
    if (query.isNotEmpty) {
      currentTag = null; 
    }
    await _loadInitial();
  }

  Future<void> _onTagSelected(String tag) async {
    currentTag = tag;
    currentSearchQuery = null;
    _searchCtrl.clear();
    await _loadInitial();
  }

  Future<void> _onTagCleared() async {
    currentTag = null;
    await _loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _listCtrl,
        slivers: [
          SliverAppBar(
            title: const ScreenTitle('Community'),
            centerTitle: true,
            pinned: false,
            floating: false,
            snap: false,
            automaticallyImplyLeading: false,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: "Search here",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchCtrl.clear();
                            _onSearch('');
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                ),
                onSubmitted: _onSearch,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: _CategoryGrid(
                items: const [
                  _CatItem("🏠", "Daily Life"),
                  _CatItem("🎓", "Campus Life"),
                  _CatItem("💼", "Jobs"),
                  _CatItem("🍜", "Food Spots"),
                  _CatItem("🏫", "SNU"),
                  _CatItem("🏫", "KU"),
                  _CatItem("🏫", "YU"),
                  _CatItem("🔜", "Next", enabled: false),
                ],
                onTagSelected: _onTagSelected,
                onTagCleared: _onTagCleared,
                currentTag: currentTag,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text("Hot Feeds 🔥",
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 8, right: 12),
                children: [
                  FeedCard(
                    feed: Feed(
                      postId: 0,
                      title: "",
                      snippet: "",
                      tags: const [],
                      createdAt: DateTime.now().toIso8601String(),
                      viewCount: 0, // 조회수를 0으로 설정하여 표시하지 않음
                      isAnnouncement: true,
                    ),
                    keywords: const ["Tips for Living in Korea"],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NoticeScreen(),
                        ),
                      );
                    },
                  ),
                  ...hotPosts.take(5).map((hotPost) {
                    final f = Feed(
                      postId: hotPost.postId,
                      title: hotPost.title,
                      snippet: hotPost.title,
                      tags: hotPost.tags,
                      createdAt: DateTime.now().toIso8601String(),
                      viewCount: hotPost.viewCount,
                    );
                    return FeedCard(
                      feed: f,
                      keywords: const [],
                      onTap: () async {
                        try {
                          print('Hot 게시물 상세 호출: ${hotPost.postId}');
                          // TODO: JWT에서 실제 user_id 가져오기!
                          const currentUserId = '1'; //임시임임
                          final post = await PostService.getPostDetail(hotPost.postId.toString(), currentUserId: currentUserId);
                          print('Hot 게시물 상세 로드 성공: ${post.title}');
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PostDetailScreen(post: post),
                              ),
                            );
                          }
                        } catch (e) {
                          print('Hot 게시물 상세 로드 실패: $e');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to load post: $e')),
                            );
                          }
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
          ),

          if (isInitialLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          else
            SliverList.builder(
              itemCount: feeds.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= feeds.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return FeedPreview(
                  feed: feeds[index],
                  onTap: () async {
                    try {
                      print('게시물 상세 호출: ${feeds[index].postId}');
                      // TODO
                      const currentUserId = '1'; // 임시로 사용자 ID 1 사용
                      final post = await PostService.getPostDetail(feeds[index].postId.toString(), currentUserId: currentUserId);
                      print('게시물 상세 로드 성공: ${post.title}');
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PostDetailScreen(post: post),
                          ),
                        );
                      }
                    } catch (e) {
                      print('게시물 상세 로드 실패: $e');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to load post: $e')),
                        );
                      }
                    }
                  },
                );
              },
            ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PostWriteScreen(),
            ),
          );
          if (result != null) {
            _loadInitial();
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }
}

//카테고리 -> 그리드
class _CatItem {
  final String emoji;
  final String label;
  final bool enabled;
  const _CatItem(this.emoji, this.label, {this.enabled = true});
}

class _CategoryGrid extends StatelessWidget {
  final List<_CatItem> items;
  final Function(String) onTagSelected;
  final VoidCallback onTagCleared;
  final String? currentTag;
  
  const _CategoryGrid({
    super.key, 
    required this.items,
    required this.onTagSelected,
    required this.onTagCleared,
    this.currentTag,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 8,
        mainAxisExtent: 70,
      ),
      itemBuilder: (context, i) {
        final it = items[i];
        return _CircleCategory(
          emoji: it.emoji,
          label: it.label,
          enabled: it.enabled,
          isSelected: currentTag == it.label,
          onTap: it.enabled ? () {
            if (currentTag == it.label) {
              onTagCleared();
            } else {
              onTagSelected(it.label);
            }
          } : null,
        );
      },
    );
  }
}

class _CircleCategory extends StatelessWidget {
  final String emoji;
  final String label;
  final bool enabled;
  final bool isSelected;
  final VoidCallback? onTap;
  
  const _CircleCategory({
    required this.emoji,
    required this.label,
    this.enabled = true,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = enabled ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.4);
    final avatarBg = isSelected 
        ? theme.colorScheme.primary
        : enabled 
            ? theme.colorScheme.surfaceVariant 
            : theme.colorScheme.surfaceVariant.withOpacity(0.5);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: avatarBg,
            child: Text(
              emoji, 
              style: TextStyle(
                fontSize: 22,
                color: isSelected ? Colors.white : null,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected ? theme.colorScheme.primary : fg,
              fontSize: 10,
              height: 1.2,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
