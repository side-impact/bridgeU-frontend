import 'package:flutter/material.dart';
import '../widgets/navigator.dart';
import '../models/feed.dart';
import '../models/post.dart';
import '../models/api_response.dart';
import '../widgets/feed_preview.dart';
import '../widgets/screen_title.dart';
import '../services/post_service.dart';
import 'post_detail_screen.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});
  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  final ScrollController _listCtrl = ScrollController();
  
  bool isLoadingMore = false;
  bool isInitialLoading = true;
  List<Feed> feeds = [];
  String? nextCursor;
  bool hasMore = true;
  String? currentTag = "Transportation";
  int? currentTagId = 8;

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

      print('공지사항 Posts 호출 시작... tagId: $currentTagId');
      final postsResult = await PostService.getPosts(
        tagId: currentTagId,
        isAnnouncement: true,
      );
      print('공지사항 Posts 호출 완료: ${postsResult.items.length}개');

      setState(() {
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
        tagId: currentTagId,
        isAnnouncement: true,
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

  int _getTagId(String tag) {
    const tagMap = {
      'Transportation': 8,
      'Convenience Store': 9,
      'Fraud Alert': 10,
    };
    return tagMap[tag] ?? 8; // 기본값으로 Transportation
  }

  Future<void> _onTagSelected(String tag) async {
    currentTag = tag;
    currentTagId = _getTagId(tag);
    print('카테고리 선택: $tag (tagId: $currentTagId)');
    await _loadInitial();
  }

  Future<void> _onTagCleared() async {
    currentTag = null;
    currentTagId = null;
    print('카테고리 선택 해제');
    await _loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _listCtrl,
        slivers: [
          SliverAppBar(
            title: const ScreenTitle('Notice'),
            centerTitle: true,
            pinned: false,
            floating: false,
            snap: false,
            automaticallyImplyLeading: true,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
              child: _NoticeCategoryGrid(
                items: const [
                  _NoticeCatItem("🚇", "Transportation"),
                  _NoticeCatItem("🏫", "Convenience Store"),
                  _NoticeCatItem("⚠️", "Fraud Alert"),
                ],
                onTagSelected: _onTagSelected,
                onTagCleared: _onTagCleared,
                currentTag: currentTag,
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
                      print('공지사항 상세 호출: ${feeds[index].postId}');
                      // TODO: 향후 사용자 인증 구현 시 실제 사용자 ID 사용
                      final post = await PostService.getPostDetail(
                        feeds[index].postId.toString()
                      );
                      print('공지사항 상세 로드 성공: ${post.title}');
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PostDetailScreen(post: post),
                          ),
                        );
                      }
                    } catch (e) {
                      print('공지사항 상세 로드 실패: $e');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to load notice: $e')),
                        );
                      }
                    }
                  },
                );
              },
            ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0), // Notice 탭 인덱스에 맞게 조정
    );
  }
}

// 공지사항 카테고리 아이템
class _NoticeCatItem {
  final String emoji;
  final String label;
  final bool enabled;
  const _NoticeCatItem(this.emoji, this.label, {this.enabled = true});
}

// 공지사항 카테고리 그리드
class _NoticeCategoryGrid extends StatelessWidget {
  final List<_NoticeCatItem> items;
  final Function(String) onTagSelected;
  final VoidCallback onTagCleared;
  final String? currentTag;
  
  const _NoticeCategoryGrid({
    super.key, 
    required this.items,
    required this.onTagSelected,
    required this.onTagCleared,
    this.currentTag,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.map((item) => Expanded(
        child: _NoticeCircleCategory(
          emoji: item.emoji,
          label: item.label,
          enabled: item.enabled,
          isSelected: currentTag == item.label,
          onTap: item.enabled ? () {
            if (currentTag == item.label) {
              onTagCleared();
            } else {
              onTagSelected(item.label);
            }
          } : null,
        ),
      )).toList(),
    );
  }
}

// 공지사항 원형 카테고리 위젯
class _NoticeCircleCategory extends StatelessWidget {
  final String emoji;
  final String label;
  final bool enabled;
  final bool isSelected;
  final VoidCallback? onTap;
  
  const _NoticeCircleCategory({
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: avatarBg,
              child: Text(
                emoji, 
                style: TextStyle(
                  fontSize: 24,
                  color: isSelected ? Colors.white : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected ? theme.colorScheme.primary : fg,
                fontSize: 12,
                height: 1.2,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
