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
  final List<bool> _viewSelection = [true, false]; // [List, Grid]

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: ToggleButtons(
                isSelected: _viewSelection,
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
                      children: <Widget>[
                        const Icon(Icons.list),
                        const SizedBox(width: 8),
                        Text(
                          'লিস্ট ভিউ',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveValue(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.grid_view),
                        const SizedBox(width: 8),
                        Text(
                          'গ্রিড ভিউ',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveValue(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _viewSelection.length; i++) {
                      _viewSelection[i] = i == index;
                    }
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: _isLoading
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
                    child: const Text('আবার চেষ্টা করুন'),
                  ),
                ],
              ),
            )
                : _categories.isEmpty
                ? const Center(child: Text('কোন ক্যাটাগরি পাওয়া যায়নি'))
                : Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
                left: 16,
                right: 16,
              ),
              child: _viewSelection[0] ? _buildListView() : _buildGridView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
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
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return _CategoryListCard(
          name: category['name'] ?? 'Uncategorized',
          postCount: (category['postCount'] ?? 0) as int,
          onTap: () => _handleCategoryTap(context, category['name'] ?? ''),
        );
      },
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
          padding: EdgeInsets.all(
            ResponsiveHelper.responsiveValue(
              context,
              mobile: 12,
              tablet: 16,
              desktop: 20,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.responsiveValue(
                    context,
                    mobile: 8,
                    tablet: 12,
                    desktop: 16,
                  ),
                ),
                decoration: BoxDecoration(
                  color: color.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getCategoryIcon(name),
                  size: ResponsiveHelper.responsiveValue(
                    context,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                  color: color,
                ),
              ),
              SizedBox(height: ResponsiveHelper.responsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              )),
              Flexible(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveValue(
                      context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 18,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: ResponsiveHelper.responsiveValue(
                context,
                mobile: 4,
                tablet: 6,
                desktop: 8,
              )),
              Text(
                '$postCount পোস্ট',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveValue(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
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
    if (lowerName.contains('বি. সি. এস.')) return Icons.gavel;
    if (lowerName.contains('নার্স')) return Icons.medical_services;
    if (lowerName.contains('ইঞ্জি')) return Icons.engineering;
    if (lowerName.contains('ব্যাংক')) return Icons.account_balance;
    if (lowerName.contains('বিদ্যালয়')) return Icons.school;
    if (lowerName.contains('চাকরি')) return Icons.work;
    return Icons.category;
  }
}

class _CategoryListCard extends StatelessWidget {
  final String name;
  final int postCount;
  final VoidCallback onTap;

  const _CategoryListCard({
    required this.name,
    required this.postCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(name);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveHelper.responsiveValue(
              context,
              mobile: 16,
              tablet: 20,
              desktop: 24,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.responsiveValue(
                    context,
                    mobile: 8,
                    tablet: 12,
                    desktop: 16,
                  ),
                ),
                decoration: BoxDecoration(
                  color: color.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getCategoryIcon(name),
                  size: ResponsiveHelper.responsiveValue(
                    context,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                  color: color,
                ),
              ),
              SizedBox(width: ResponsiveHelper.responsiveValue(
                context,
                mobile: 16,
                tablet: 20,
                desktop: 24,
              )),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
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
                      mobile: 4,
                      tablet: 6,
                      desktop: 8,
                    )),
                    Text(
                      '$postCount পোস্ট',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveValue(
                          context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 18,
                        ),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: ResponsiveHelper.responsiveValue(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
                color: Colors.grey,
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
    if (lowerName.contains('বি. সি. এস.')) return Icons.gavel;
    if (lowerName.contains('নার্স')) return Icons.medical_services;
    if (lowerName.contains('ইঞ্জি')) return Icons.engineering;
    if (lowerName.contains('ব্যাংক')) return Icons.account_balance;
    if (lowerName.contains('বিদ্যালয়')) return Icons.school;
    if (lowerName.contains('চাকরি')) return Icons.work;
    return Icons.category;
  }
}