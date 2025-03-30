import 'package:flutter/material.dart';
import 'package:examplay/services/blogger_service.dart';
import 'package:examplay/screens/category_posts_screen.dart';
import 'package:examplay/utils/responsive_helper.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  final BloggerService _bloggerService = BloggerService();
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final categories = await _bloggerService.fetchCategories();
      if (mounted) {
        setState(() {
          _categories = List<Map<String, dynamic>>.from(categories);
          _categories.sort((a, b) => (b['postCount'] ?? 0).compareTo(a['postCount'] ?? 0));
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load categories';
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

  void _handleCategoryTap(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPostsScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCategories,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : _categories.isEmpty
          ? const Center(child: Text('No categories available'))
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.responsiveGridCount(
            context,
            mobile: 2,
            tablet: 3,
            desktop: 4,
          ),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: ResponsiveHelper.responsiveValue(
            context,
            mobile: 0.9,
            tablet: 1.0,
            desktop: 1.1,
          ),
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return _CategoryCard(
            name: category['name'] ?? 'Uncategorized',
            postCount: (category['postCount'] ?? 0) as int,
            onTap: () => _handleCategoryTap(context, category['name'] ?? ''),
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final int postCount;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.postCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(name);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getCategoryIcon(name),
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                '$postCount posts',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String categoryName) {
    final colors = [
      const Color(0xFF4289CE),
      const Color(0xFFF7953E),
      const Color(0xFF2DBBBF),
      const Color(0xFFF15B38),
      const Color(0xFF8E44AD),
      const Color(0xFF27AE60),
    ];
    return colors[categoryName.hashCode % colors.length];
  }

  IconData _getCategoryIcon(String categoryName) {
    final lowerName = categoryName.toLowerCase();
    if (lowerName.contains('univ')) return Icons.school;
    if (lowerName.contains('med')) return Icons.medical_services;
    if (lowerName.contains('eng')) return Icons.engineering;
    if (lowerName.contains('bank')) return Icons.account_balance;
    if (lowerName.contains('bcs')) return Icons.gavel;
    if (lowerName.contains('job')) return Icons.work;
    return Icons.category;
  }
}