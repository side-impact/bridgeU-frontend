import 'package:flutter/material.dart';
import '../models/post.dart';

class PostBlockView extends StatelessWidget {
  final PostBlock block;
  const PostBlockView({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case PostBlockType.paragraph:
        return _Paragraph(text: block.text ?? '');
      case PostBlockType.image:
        return _BlockImage(url: block.imageUrl ?? '');
    }
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SelectableText(
        text,
        style: const TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }
}

class _BlockImage extends StatelessWidget {
  final String url;
  const _BlockImage({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.network(url, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
