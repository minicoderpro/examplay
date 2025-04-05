import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class PostCard extends StatelessWidget {
  final dynamic post;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.post,
    this.onTap = _defaultOnTap,
  });

  static void _defaultOnTap() {}

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = post['images']?.isNotEmpty == true
        ? post['images'][0]['url']
        : 'https://via.placeholder.com/150';

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.responsiveValue(
          context,
          mobile: 8,
          tablet: 12,
          desktop: 16,
        ),
        vertical: ResponsiveHelper.responsiveValue(
          context,
          mobile: 4,
          tablet: 6,
          desktop: 8,
        ),
      ),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveHelper.responsiveValue(
              context,
              mobile: 8,
              tablet: 10,
              desktop: 12,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ResponsiveHelper.responsiveValue(
                  context,
                  mobile: 60,
                  tablet: 80,
                  desktop: 100,
                ),
                height: ResponsiveHelper.responsiveValue(
                  context,
                  mobile: 60,
                  tablet: 80,
                  desktop: 100,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: NetworkImage(thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.responsiveValue(
                context,
                mobile: 8,
                tablet: 12,
                desktop: 16,
              )),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['title'] ?? 'No title',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveValue(
                          context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 18,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _extractPlainText(post['content'] ?? ''),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveValue(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _formatDate(post['published'] ?? ''),
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveValue(
                            context,
                            mobile: 10,
                            tablet: 12,
                            desktop: 14,
                          ),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _extractPlainText(String htmlString) {
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}