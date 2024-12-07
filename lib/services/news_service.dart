import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  //The API Key
  final String apiKey = '8e2a98d93f5c429e9548e29080a19e0c';

  // The API URL
  final String apiUrl = 'https://newsapi.org/v2/top-headlines?country=us';

  // GET news from the API
  Future<List<NewsArticle>> fetchTopHeadlines({String? category}) async {
    final url = category != null
        ? 'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$apiKey'
        : 'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List articles = data['articles'];
      return articles.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news articles');
    }
  }

  //Search news
  Future<List<NewsArticle>> searchNews(String query) async {
    final url =
        'https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List articles = data['articles'];
      return articles.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news articles');
    }
  }

  //Filter news by category
  Future<List<NewsArticle>> fetchNewsByCategory(String category) async {
    final response = await http.get(Uri.parse('$apiUrl&category=$category&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      List articlesJson = jsonDecode(response.body)['articles'];
      return articlesJson.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news by category');
    }
  }
}
