import 'dart:convert';
import 'package:http/http.dart' as http;

class BloggerService {
  static const String _apiKey = "AIzaSyDwWnIbLN72FsWWuq3Zf9_Pf5i9dyR5Uz0";
  static const String _blogId = "4192916477317070222";
  static const String _baseUrl = "https://www.googleapis.com/blogger/v3/blogs";

  // Fetch all posts (used in homepage)
  Future<Map<String, dynamic>> fetchPosts({int maxResults = 10, String? pageToken}) async {
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
  }

  // Fetch categories (used in categories tab)
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      // First fetch all posts to extract labels
      final postsResponse = await http.get(
        Uri.parse('$_baseUrl/$_blogId/posts?key=$_apiKey&maxResults=500&fields=items(labels)'),
      );

      if (postsResponse.statusCode == 200) {
        final postsData = json.decode(postsResponse.body);
        final posts = postsData['items'] as List? ?? [];

        // Extract all unique labels and count posts per label
        final categoryMap = <String, int>{};

        for (final post in posts) {
          final labels = post['labels'] as List? ?? [];
          for (final label in labels) {
            if (label != null) {
              categoryMap[label] = (categoryMap[label] ?? 0) + 1;
            }
          }
        }

        // Convert to list of category objects sorted by post count
        return categoryMap.entries.map((entry) {
          return {
            'name': entry.key,
            'postCount': entry.value,
          };
        }).toList()
          ..sort((a, b) => (b['postCount'] as int).compareTo(a['postCount'] as int));
      } else {
        throw Exception('Failed to load posts: ${postsResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // Fetch posts by category (used in category posts screen)
  Future<Map<String, dynamic>> fetchPostsByCategory(String category, {int maxResults = 10, String? pageToken}) async {
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
  }
}