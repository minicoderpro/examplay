import 'dart:convert';
import 'package:http/http.dart' as http;

class BloggerService {
  static const String _apiKey = "AIzaSyDwWnIbLN72FsWWuq3Zf9_Pf5i9dyR5Uz0";
  static const String _blogId = "4192916477317070222";
  static const String _baseUrl = "https://www.googleapis.com/blogger/v3/blogs";

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
      throw Exception('Failed to load posts');
    }
  }
}