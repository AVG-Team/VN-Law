class NewsArticle {
  final String? articleId;
  final String? title;
  final List<dynamic> category;
  final String? description;
  final String? pubDate;
  final String? imageUrl;
  final String? sourceName;
  final String? link;
  final String? content;

  NewsArticle({
    this.articleId,
    this.title,
    required this.category,
    this.description,
    this.pubDate,
    this.imageUrl,
    this.sourceName,
    this.link,
    this.content,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      articleId: json['article_id'] as String?,
      title: json['title'] as String?,
      category: json['category'] != null ? List<dynamic>.from(json['category']) : [],
      description: json['description'] as String?,
      pubDate: json['pubDate'] as String?,
      imageUrl: json['image_url'] as String?,
      sourceName: json['source_name'] as String?,
      link: json['link'] as String?,
      content: json['content'] ?? '',
    );
  }
}
