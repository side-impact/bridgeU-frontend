import 'package:flutter/material.dart';
import '../models/feed.dart';
import '../utils/tag_labels.dart';

class FeedCard extends StatelessWidget {
  final Feed feed;
  final List<String> keywords;
  final VoidCallback? onTap;

  const FeedCard({
    super.key,
    required this.feed,
    this.keywords = const [],
    this.onTap,
  });

  String _getTagName(dynamic tag) {
    if (tag is int) {
      return TagLabels.of(tag);
    }
    final intTag = int.tryParse(tag.toString());
    return intTag != null ? TagLabels.of(intTag) : tag.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isAnn = feed.isAnnouncement;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 160,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isAnn ? const Color(0xFF34C6A8) : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (keywords.isNotEmpty)
              Wrap(
                spacing: 6,
                children: keywords.map((k) => Text(
                  k,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isAnn ? Colors.white : Colors.black87,
                  ),
                )).toList(),
              ),

            const SizedBox(height: 6),

            Expanded(
              child: isAnn
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: feed.tags.map((t) => Text(
                        _getTagName(t),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )).toList(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (feed.tags.isNotEmpty)
                          Wrap(
                            spacing: 4,
                            runSpacing: 2,
                            children: feed.tags.map((t) => Text(
                              _getTagName(t),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            )).toList(),
                          ),
                        if (feed.tags.isNotEmpty) const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            feed.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 4),

            if (feed.views > 0) // 조회수가 0보다 클 때만 표시
              Row(
                children: [
                  Icon(Icons.remove_red_eye,
                      size: 14, color: isAnn ? Colors.white70 : Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "${feed.views}",
                    style: TextStyle(
                      fontSize: 12,
                      color: isAnn ? Colors.white70 : Colors.grey[700],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
