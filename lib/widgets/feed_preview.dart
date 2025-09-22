import 'package:flutter/material.dart';
import '../models/feed.dart';
import '../utils/tag_labels.dart';

class FeedPreview extends StatelessWidget {
  final Feed feed;
  final VoidCallback? onTap;

  const FeedPreview({super.key, required this.feed, this.onTap});

  String _getTagName(dynamic tag) {
    if (tag is int) {
      return TagLabels.of(tag);
    }
    final intTag = int.tryParse(tag.toString());
    return intTag != null ? TagLabels.of(intTag) : tag.toString();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (feed.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: feed.tags.map((t) => Text(
                        _getTagName(t),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      )).toList(),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    feed.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feed.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (feed.images.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  feed.images.first,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
