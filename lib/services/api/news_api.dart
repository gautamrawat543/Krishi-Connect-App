import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  static const String _apiKey =
      "338a7453e57642118289ed79723836a5"; // Your API key
  static const String _baseUrl =
      "https://newsapi.org/v2/everything?q=best%20farming%20practices&apiKey=$_apiKey&pageSize=10";

  static Future<List<dynamic>> fetchNews(int page) async {
    final response = await http.get(Uri.parse('$_baseUrl&page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles']; // Returns list of articles
    } else {
      throw Exception("Failed to load news");
    }
  }
}
