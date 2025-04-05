import 'package:flutter/material.dart';
import 'package:examplay/services/blogger_service.dart';
import 'package:examplay/widgets/post_card.dart';
import 'package:examplay/widgets/post_grid_item.dart';
import 'package:examplay/screens/categories_tab.dart';
import 'package:examplay/screens/developer_tab.dart';
import '../utils/responsive_helper.dart';
import '../widgets/post_detail_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final BloggerService _bloggerService = BloggerService();
  List<dynamic> _posts = [];
  List<dynamic> _filteredPosts = [];
  String? _nextPageToken;
  bool _isLoading = false;
  bool _isGridView = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showSearchBar = false;
  double _scaleFactor = 1.0;
  final double _scaleThreshold = 1.2;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (_nextPageToken != null && !_isLoading) {
        _loadPosts(loadMore: true);
      }
    }
  }

  Future<void> _loadPosts({bool loadMore = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final data = await _bloggerService.fetchPosts(
        maxResults: 10,
        pageToken: loadMore ? _nextPageToken : null,
      );

      if (mounted) {
        setState(() {
          if (loadMore) {
            _posts.addAll(data['items']);
            _filteredPosts.addAll(data['items']);
          } else {
            _posts = data['items'];
            _filteredPosts = data['items'];
          }
          _nextPageToken = data['nextPageToken'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading posts: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterPosts(String query) {
    setState(() {
      _filteredPosts = _posts.where((post) {
        final title = post['title'].toString().toLowerCase();
        final content = post['content'].toString().toLowerCase();
        return title.contains(query.toLowerCase()) || content.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _showSearchBar
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search posts...',
            hintStyle: TextStyle(color: Colors.black54),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () {
                setState(() {
                  _showSearchBar = false;
                  _searchController.clear();
                  _filterPosts('');
                });
              },
            ),
          ),
          style: const TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          onChanged: _filterPosts,
        )
            : const Text(
          'Examplay',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () => setState(() => _showSearchBar = true),
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onScaleUpdate: (details) {
          if (details.scale > _scaleThreshold && !_isGridView) {
            setState(() => _isGridView = true);
          } else if (details.scale < 1/_scaleThreshold && _isGridView) {
            setState(() => _isGridView = false);
          }
        },
        child: _buildCurrentTab(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            selectedItemColor: const Color(0xFF4289CE),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Developer',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const CategoriesTab();
      case 2:
        return const DeveloperTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildHomeTab() {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _loadPosts(loadMore: false),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  sliver: _isGridView ? _buildPostGrid() : _buildPostList(),
                ),
                if (_isLoading && _nextPageToken != null)
                  const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) => PostCard(
          post: _filteredPosts[index],
          onTap: () => _navigateToDetail(_filteredPosts[index]),
        ),
        childCount: _filteredPosts.length,
      ),
    );
  }

  Widget _buildPostGrid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.responsiveGridCount(
          context,
          mobile: 2,
          tablet: 3,
          desktop: 4,
        ),
        childAspectRatio: ResponsiveHelper.responsiveValue(
          context,
          mobile: 0.7,
          tablet: 0.8,
          desktop: 0.9,
        ),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) => PostGridItem(
          post: _filteredPosts[index],
          onTap: () => _navigateToDetail(_filteredPosts[index]),
        ),
        childCount: _filteredPosts.length,
      ),
    );
  }

  void _navigateToDetail(dynamic post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailView(post: post),
      ),
    );
  }
}