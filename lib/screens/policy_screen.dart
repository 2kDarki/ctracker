import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PolicyScreen extends StatelessWidget {
  final String title;
  final String content;

  const PolicyScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Markdown(
          data: content,
          padding: const EdgeInsets.all(16),
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            h1: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            h2: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            p: Theme.of(context).textTheme.bodyMedium,
            listBullet: Theme.of(context).textTheme.bodyMedium,
            strong: const TextStyle(fontWeight: FontWeight.bold),
            blockquoteDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
