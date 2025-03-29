import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PostDetailView extends StatelessWidget {
  final dynamic post;

  const PostDetailView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              post['title'] ?? 'No title',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            backgroundColor: const Color(0xFF4289CE),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                post['images']?.isNotEmpty == true
                    ? post['images'][0]['url']
                    : 'https://via.placeholder.com/400',
                fit: BoxFit.cover,
              ),
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'] ?? 'No title',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Html(data: post['content'] ?? 'No content'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}