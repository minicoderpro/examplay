import 'package:flutter/material.dart';
import 'package:examplay/services/blogger_service.dart';
import 'package:examplay/widgets/post_card.dart';

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
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCategoryPosts();
  }

  Future<void> _fetchCategoryPosts() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final data = await _bloggerService.fetchPostsByCategory(widget.category);
      if (mounted) {
        setState(() {
          _posts = data['items'] ?? [];
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load posts for ${widget.category}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _posts.isEmpty
          ? const Center(child: Text('No posts found in this category'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: _posts[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchCategoryPosts,
        backgroundColor: const Color(0xFF4289CE),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}