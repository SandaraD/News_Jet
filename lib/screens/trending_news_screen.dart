import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';
import 'full_news_screen.dart';
import '';

class TrendingNewsScreen extends StatefulWidget {
  @override
  _TrendingNewsScreenState createState() => _TrendingNewsScreenState();
}

class _TrendingNewsScreenState extends State<TrendingNewsScreen> {
  late Future<List<NewsArticle>> futureTrendingArticles;

  @override
  void initState() {
    super.initState();
    futureTrendingArticles = NewsService().fetchTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending News'),
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: futureTrendingArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No trending news found'));
          }

          List<NewsArticle> trendingArticles = snapshot.data!;

          return ListView.builder(
            itemCount: trendingArticles.length,
            itemBuilder: (context, index) {
              NewsArticle article = trendingArticles[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                        builder: (context) => FullNewsScreen(article: article),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                article.publishedAt,
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
          );
        },
      ),
    );
  }
}
