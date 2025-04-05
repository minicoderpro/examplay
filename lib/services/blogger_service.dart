import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class BloggerService {
  static const String _apiKey = "AIzaSyDwWnIbLN72FsWWuq3Zf9_Pf5i9dyR5Uz0";
  static const String _blogId = "4192916477317070222";
  static const String _baseUrl = "https://www.googleapis.com/blogger/v3/blogs";

  static List<Map<String, dynamic>>? _cachedCategories;
  static Completer<List<Map<String, dynamic>>>? _categoriesCompleter;

  Future<Map<String, dynamic>> fetchPosts({int maxResults = 10, String? pageToken}) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/$_blogId/posts?key=$_apiKey'
              '&maxResults=$maxResults'
              '${pageToken != null ? '&pageToken=$pageToken' : ''}'
              '&fetchBodies=true'
              '&fetchImages=true'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    if (_cachedCategories != null) return _cachedCategories!;
    if (_categoriesCompleter != null) return _categoriesCompleter!.future;

    _categoriesCompleter = Completer();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$_blogId/posts?key=$_apiKey&maxResults=500&fields=items(labels)'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final posts = data['items'] as List? ?? [];
        final categoryMap = <String, int>{};

        for (final post in posts) {
          final labels = post['labels'] as List? ?? [];
          for (final label in labels) {
            if (label != null) {
              categoryMap[label] = (categoryMap[label] ?? 0) + 1;
            }
          }
        }

        _cachedCategories = categoryMap.entries.map((entry) {
          return {
            'name': entry.key,
            'postCount': entry.value,
          };
        }).toList()
          ..sort((a, b) => (b['postCount'] as int).compareTo(a['postCount'] as int));

        _categoriesCompleter!.complete(_cachedCategories);
        return _cachedCategories!;
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      _categoriesCompleter!.completeError(e);
      throw Exception('Failed to fetch categories: $e');
    } finally {
      _categoriesCompleter = null;
    }
  }

  Future<Map<String, dynamic>> fetchPostsByCategory(String category, {int maxResults = 10, String? pageToken}) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/$_blogId/posts?key=$_apiKey'
              '&maxResults=$maxResults'
              '${pageToken != null ? '&pageToken=$pageToken' : ''}'
              '&fetchBodies=true'
              '&fetchImages=true'
              '&labels=${Uri.encodeComponent(category)}'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load posts for category $category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}