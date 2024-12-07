import 'package:flutter/material.dart';
import '../models/news_model.dart';

class FullNewsScreen extends StatelessWidget {
  final NewsArticle article;

  FullNewsScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full News'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Published on: ${article.publishedAt}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              article.content ?? 'No content available.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Source: ${article.url}',
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
