import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/news_model.dart';
import 'full_news_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<NewsArticle> favoriteArticles;

  FavoritesScreen({required this.favoriteArticles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favoriteArticles.isEmpty
          ? Center(
        child: Text(
          'No favorite articles yet.',
          style: TextStyle(fontSize: 16.0),
        ),
      )
          : ListView.builder(
        itemCount: favoriteArticles.length,
        itemBuilder: (context, index) {
          NewsArticle article = favoriteArticles[index];

          // formatting the published date
          String formattedDate =
          timeago.format(DateTime.parse(article.publishedAt));

          return Card(
            margin:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FullNewsScreen(article: article),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // small image preview
                    if (article.urlToImage.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          article.urlToImage,
                          height: 80.0,
                          width: 80.0,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Icon(
                          Icons.broken_image,
                          size: 40.0,
                          color: Colors.grey[500],
                        ),
                      ),
                    const SizedBox(width: 12.0),
                    // News Title and date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
