import 'package:flutter/material.dart';
import 'package:examplay/services/blogger_service.dart';
import 'package:examplay/widgets/post_detail_view.dart';
import '../utils/responsive_helper.dart';
import '../widgets/load_more_button.dart';

class CategoryPostsScreen extends StatefulWidget {
  final String category;

  const CategoryPostsScreen({super.key, required this.category});

  @override
  State<CategoryPostsScreen> createState() => _CategoryPostsScreenState();
}

class _CategoryPostsScreenState extends State<CategoryPostsScreen> {
  final BloggerService _bloggerService = BloggerService();
  List<dynamic> _posts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  String? _nextPageToken;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (_nextPageToken != null && !_isLoadingMore) {
        _loadPosts(loadMore: true);
      }
    }
  }

  Future<void> _loadPosts({bool loadMore = false}) async {
    if (loadMore ? _isLoadingMore : _isLoading) return;

    setState(() {
      loadMore ? _isLoadingMore = true : _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _bloggerService.fetchPostsByCategory(
        widget.category,
        pageToken: loadMore ? _nextPageToken : null,
      );

      if (mounted) {
        setState(() {
          if (loadMore) {
            _posts.addAll(data['items'] ?? []);
          } else {
            _posts = data['items'] ?? [];
          }
          _nextPageToken = data['nextPageToken'];
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load posts';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          loadMore ? _isLoadingMore = false : _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: const Color(0xFF4289CE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading && !_isLoadingMore
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _posts.isEmpty
                ? Center(child: Text('No posts in ${widget.category}'))
                : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(
                ResponsiveHelper.responsiveValue(
                  context,
                  mobile: 16,
                  tablet: 24,
                  desktop: 32,
                ),
              ),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                final thumbnailUrl = post['images']?.isNotEmpty == true
                    ? post['images'][0]['url']
                    : 'https://via.placeholder.com/150';

                return Card(
                  margin: EdgeInsets.only(
                    bottom: ResponsiveHelper.responsiveValue(
                      context,
                      mobile: 16,
                      tablet: 20,
                      desktop: 24,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => _showPostDetail(context, post),
                    child: Padding(
                      padding: EdgeInsets.all(
                        ResponsiveHelper.responsiveValue(
                          context,
                          mobile: 12,
                          tablet: 16,
                          desktop: 20,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: ResponsiveHelper.responsiveValue(
                              context,
                              mobile: 80,
                              tablet: 100,
                              desktop: 120,
                            ),
                            height: ResponsiveHelper.responsiveValue(
                              context,
                              mobile: 80,
                              tablet: 100,
                              desktop: 120,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(thumbnailUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.responsiveValue(
                            context,
                            mobile: 12,
                            tablet: 16,
                            desktop: 20,
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
                                      mobile: 16,
                                      tablet: 18,
                                      desktop: 20,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: ResponsiveHelper.responsiveValue(
                                  context,
                                  mobile: 8,
                                  tablet: 10,
                                  desktop: 12,
                                )),
                                Text(
                                  _extractPlainText(post['content'] ?? ''),
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.responsiveValue(
                                      context,
                                      mobile: 14,
                                      tablet: 16,
                                      desktop: 18,
                                    ),
                                    color: Colors.grey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: ResponsiveHelper.responsiveValue(
                                  context,
                                  mobile: 8,
                                  tablet: 10,
                                  desktop: 12,
                                )),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    _formatDate(post['published'] ?? ''),
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.responsiveValue(
                                        context,
                                        mobile: 12,
                                        tablet: 14,
                                        desktop: 16,
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
              },
            ),
          ),
          if (_nextPageToken != null && _isLoadingMore)
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: CircularProgressIndicator(),
            ),
          if (_nextPageToken != null && !_isLoadingMore && !_isLoading)
            LoadMoreButton(
              isLoading: false,
              onPressed: () => _loadPosts(loadMore: true),
            ),
        ],
      ),
    );
  }

  void _showPostDetail(BuildContext context, dynamic post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailView(post: post),
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