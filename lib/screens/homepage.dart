import 'package:flutter/material.dart';
import 'package:examplay/services/blogger_service.dart';
import 'package:examplay/widgets/image_slider.dart';
import 'package:examplay/widgets/search_bar.dart';
import 'package:examplay/widgets/post_card.dart';
import 'package:examplay/widgets/post_grid_item.dart';
import 'package:examplay/widgets/load_more_button.dart';
import 'package:examplay/screens/categories_tab.dart';
import 'package:examplay/screens/developer_tab.dart';

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
  bool _showLoadMore = false;
  bool _isGridView = false;
  final TextEditingController _searchController = TextEditingController();
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
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      setState(() {
        _showLoadMore = true;
      });
    }
  }

  Future<void> _loadPosts({bool loadMore = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _showLoadMore = false;
    });

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
        return title.contains(query.toLowerCase()) ||
            content.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Examplay'),
        backgroundColor: const Color(0xFF4289CE),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showLoadMore && _nextPageToken != null && _currentIndex == 0)
            LoadMoreButton(
              isLoading: _isLoading,
              onPressed: () => _loadPosts(loadMore: true),
            ),
          _buildBottomNavigationBar(),
        ],
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
        if (_filteredPosts.isNotEmpty)
          ImageSlider(posts: _filteredPosts.length > 5 ? _filteredPosts.sublist(0, 5) : _filteredPosts),

        SearchBarWithToggle(
          controller: _searchController,
          isGridView: _isGridView,
          onChanged: _filterPosts,
          onTogglePressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
        ),

        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _loadPosts(loadMore: false),
            child: _isGridView ? _buildPostGrid() : _buildPostList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPostList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: _filteredPosts.length,
      itemBuilder: (context, index) {
        return PostCard(post: _filteredPosts[index]);
      },
    );
  }

  Widget _buildPostGrid() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _filteredPosts.length,
      itemBuilder: (context, index) {
        return PostGridItem(post: _filteredPosts[index]);
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      selectedItemColor: const Color(0xFF4289CE),
      unselectedItemColor: const Color(0xFF888888),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Developer',
        ),
      ],
    );
  }
}