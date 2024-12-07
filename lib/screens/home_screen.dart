import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/news_model.dart';
import '../providers/news_provider.dart';
import 'full_news_screen.dart';
import 'trending_news_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'business';
  int selectedIndex = 0;
  List<NewsArticle> favoriteArticles = [];
  final List<String> categories = [
    'business',
    'sports',
    'technology',
    'entertainment',
    'health',
    'science',
  ];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    Provider.of<NewsProvider>(context, listen: false).fetchNewsByCategory(selectedCategory);
  }

  // Search News
  void _searchNews(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        Provider.of<NewsProvider>(context, listen: false).searchNews(query);
      } else {
        Provider.of<NewsProvider>(context, listen: false).fetchNewsByCategory(selectedCategory);
      }
    });
  }

  // Change category
  void _changeCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    Provider.of<NewsProvider>(context, listen: false).fetchNewsByCategory(selectedCategory);
  }

  // Toggle favorite news articles
  void toggleFavorite(NewsArticle article) {
    setState(() {
      article.isFavorite = !article.isFavorite;
      if (article.isFavorite) {
        favoriteArticles.add(article);
      } else {
        favoriteArticles.remove(article);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedIndex == 0 ? 'All News' : 'Favorites'),
      ),
      body: selectedIndex == 0 ? _buildAllNews() : _buildFavorites(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'All News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildAllNews() {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _searchNews(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Category Dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal[100],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newCategory) {
                        if (newCategory != null) {
                          _changeCategory(newCategory);
                        }
                      },
                      items: categories.map<DropdownMenuItem<String>>((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category.capitalize(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      dropdownColor: Colors.teal[100],
                      iconEnabledColor: Colors.black,
                      underline: SizedBox(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),

                  // Trending Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrendingNewsScreen()),
                      );
                    },
                    icon: Icon(Icons.trending_up),
                    label: Text('Trending'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[400],
                      foregroundColor: Colors.white,
                      elevation: 2.0,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: newsProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildNewsList(newsProvider.newsArticles),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFavorites() {
    return favoriteArticles.isEmpty
        ? Center(child: Text('No favorite articles'))
        : _buildNewsList(favoriteArticles);
  }

  Widget _buildNewsList(List<NewsArticle> newsArticles) {
    return ListView.builder(
      itemCount: newsArticles.length,
      itemBuilder: (context, index) {
        NewsArticle article = newsArticles[index];

        String formattedDate = timeago.format(DateTime.parse(article.publishedAt));

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
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          article.source.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                toggleFavorite(article);
                              },
                              icon: Icon(
                                article.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: article.isFavorite ? Colors.red : Colors.grey,
                              ),
                            ),
                          ],
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
  }
}

extension Capitalize on String {
  String capitalize() {
    if (this.isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

