import 'dart:async';
import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _newsService = NewsService();

  List<NewsArticle> _newsArticles = [];
  String _errorMessage = '';
  bool _isLoading = false;

  // Getters
  bool get isLoading => _isLoading;
  List<NewsArticle> get newsArticles => _newsArticles;
  String get errorMessage => _errorMessage;

  // Fetch News by Category
  Future<void> fetchNewsByCategory(String category) async {
    _isLoading = false;
    _errorMessage = '';
    notifyListeners();

    try {
      _newsArticles = await _newsService.fetchNewsByCategory(category);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Could not load news for this category. Please try again';
      notifyListeners();
    }
  }

  // Search News by Query
  Future<void> searchNews(String query) async {
    _isLoading = true;
    _errorMessage = '';
    _newsArticles = [];
    notifyListeners();

    try {
      _newsArticles = await _newsService.searchNews(query);
    } catch (e) {
      _errorMessage = 'Failed to search news. Please check your connection';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
