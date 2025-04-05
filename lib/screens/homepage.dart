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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_nextPageToken != null && !_isLoading) {
        _loadPosts(loadMore: true);
      }
    }
  }

  Future<void> _loadPosts({bool loadMore = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
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
        title: _showSearchBar
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search posts...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _showSearchBar = false;
                  _searchController.clear();
                  _filterPosts('');
                });
              },
            ),
          ),
          onChanged: _filterPosts,
        )
            : const Text('Examplay'),
        backgroundColor: const Color(0xFF4289CE),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _showSearchBar = true;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
        if (_currentIndex == 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: ToggleButtons(
                isSelected: [!_isGridView, _isGridView],
                selectedColor: Colors.white,
                fillColor: const Color(0xFF4289CE),
                borderRadius: BorderRadius.circular(30),
                constraints: BoxConstraints(
                  minHeight: 40,
                  minWidth: ResponsiveHelper.responsiveValue(
                    context,
                    mobile: 120,
                    tablet: 140,
                    desktop: 160,
                  ),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.list),
                        SizedBox(width: 8),
                        Text('লিস্ট ভিউ'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.grid_view),
                        SizedBox(width: 8),
                        Text('গ্রিড ভিউ'),
                      ],
                    ),
                  ),
                ],
                onPressed: (int index) {
                  setState(() {
                    _isGridView = index == 1;
                  });
                },
              ),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _loadPosts(loadMore: false),
            child: _isGridView ? _buildPostGrid() : _buildPostList(),
          ),
        ),
        if (_isLoading && _nextPageToken != null)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
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
        return PostCard(
          post: _filteredPosts[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailView(post: _filteredPosts[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPostGrid() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
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
      itemCount: _filteredPosts.length,
      itemBuilder: (context, index) {
        return PostGridItem(
          post: _filteredPosts[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailView(post: _filteredPosts[index]),
              ),
            );
          },
        );
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
          icon: Icon(Icons.category),
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