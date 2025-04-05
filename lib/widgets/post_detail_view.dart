import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../utils/responsive_helper.dart';

class PostDetailView extends StatelessWidget {
  final dynamic post;

  const PostDetailView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              post['title'] ?? 'No title',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            expandedHeight: ResponsiveHelper.responsiveValue(
              context,
              mobile: 200,
              tablet: 300,
              desktop: 400,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                post['images']?.isNotEmpty == true
                    ? post['images'][0]['url']
                    : 'https://via.placeholder.com/400',
                fit: BoxFit.cover,
              ),
            ),
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.black),
            actionsIconTheme: const IconThemeData(color: Colors.black),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(
                ResponsiveHelper.responsiveValue(
                  context,
                  mobile: 16,
                  tablet: 24,
                  desktop: 32,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Html(
                    data: post['content'] ?? 'No content',
                    style: {
                      "body": Style(
                        fontSize: FontSize(ResponsiveHelper.responsiveValue(
                          context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 18,
                        )),
                      ),
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}