class NewsArticle {
  final String? articleId;
  final String? title;
  final List<dynamic> category;
  final String? description;
  final String? pubDate;
  final String? imageUrl;
  final String? sourceName;
  final String? link;
  final String content;

  NewsArticle({
    required this.articleId,
    required this.title,
    required this.category,
    required this.description,
    required this.pubDate,
    required this.imageUrl,
    required this.sourceName,
    required this.link,
    required this.content
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      articleId: json['article_id'],
      title: json['title'],
      category: json['category'],
      description: json['description'],
      pubDate: json['pubDate'],
      imageUrl: json['image_url'],
      sourceName: json['source_name'],
      link: json['link'],
      content: json['content']
    );
  }
}
