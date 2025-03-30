import 'package:examplay/widgets/post_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../utils/responsive_helper.dart';

class ImageSlider extends StatefulWidget {
  final List<dynamic> posts;

  const ImageSlider({super.key, required this.posts});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Update image_slider.dart
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.responsiveValue(
        context,
        mobile: 220,
        tablet: 280,
        desktop: 320,
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.posts.length,
            itemBuilder: (context, index) {
              final post = widget.posts[index];
              final imageUrl = post['images']?.isNotEmpty == true
                  ? post['images'][0]['url']
                  : 'https://via.placeholder.com/400x180';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailView(post: post),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.responsiveValue(
                      context,
                      mobile: 16,
                      tablet: 24,
                      desktop: 32,
                    ),
                    vertical: ResponsiveHelper.responsiveValue(
                      context,
                      mobile: 8,
                      tablet: 12,
                      desktop: 16,
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(
                            ResponsiveHelper.responsiveValue(
                              context,
                              mobile: 12,
                              tablet: 16,
                              desktop: 20,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withAlpha(204),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['title'],
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.responsiveValue(
                                    context,
                                    mobile: 16,
                                    tablet: 18,
                                    desktop: 20,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: ResponsiveHelper.responsiveValue(
                                context,
                                mobile: 4,
                                tablet: 6,
                                desktop: 8,
                              )),
                              Text(
                                _extractPlainText(post['content']),
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.responsiveValue(
                                    context,
                                    mobile: 12,
                                    tablet: 14,
                                    desktop: 16,
                                  ),
                                  color: Colors.white.withAlpha(229),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: ResponsiveHelper.responsiveValue(
              context,
              mobile: 20,
              tablet: 24,
              desktop: 28,
            ),
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: widget.posts.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Color(0xFF4289CE),
                  dotColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _extractPlainText(String htmlString) {
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')  // Remove HTML tags
        .replaceAll(RegExp(r'\s+'), ' ')    // Remove extra spaces
        .trim();                            // Trim extra spaces
  }
}
