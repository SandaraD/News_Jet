class NewsArticle {
  final String title;
  final String description;
  final String urlToImage;
  final String url;
  final String publishedAt;
  final String? content;
  bool isFavorite;
  final Source source;

  NewsArticle({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url,
    required this.publishedAt,
    this.content,
    this.isFavorite = false,
    required this.source,
  });

  // Factory method to create a NewsArticle from JSON
  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description',
      urlToImage: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
      publishedAt: json['publishedAt'] ?? 'No date',
      content: json['content'] ?? 'No content',
      isFavorite: false,
      source: Source.fromJson(json['source'] ?? {}),
    );
  }
}

class Source {
  final String name; // Name of the source (e.g., news agency or website)

  Source({required this.name});

  // Factory method to create a Source from JSON
  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      name: json['name'] ?? 'Unknown source',
    );
  }
}