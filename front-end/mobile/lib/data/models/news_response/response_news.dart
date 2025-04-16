import 'dart:convert';

ResponseNews responseNewsFromJson(String str) =>
    ResponseNews.fromJson(json.decode(str));

String responseNewsToJson(ResponseNews data) => json.encode(data.toJson());

class ResponseNews {
  ResponseNews({
    this.data,
    this.status,
    this.totalResults,
    this.message,
  });

  bool? status;
  int? totalResults;
  String? message;
  List<NewsArticle>? data;

  factory ResponseNews.fromJson(Map<String, dynamic> json) => ResponseNews(
    status: json["status"] == "success",
    message: json["message"],
    data: json["results"] != null ? List<NewsArticle>.from(json["results"].map((x) => NewsArticle.fromJson(x))) : null,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "totalResults": totalResults,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NewsArticle {
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

  String? articleId;
  String? title;
  List<dynamic> category;
  String? description;
  String? pubDate;
  String? imageUrl;
  String? sourceName;
  String? link;
  String? content;

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

  Map<String, dynamic> toJson() => {
    "articleId": articleId,
    "title": title,
    "category": category,
    "description": description,
    "pubDate": pubDate,
    "imageUrl": imageUrl,
    "sourceName": sourceName,
    "link": link,
    "content": content,
  };
}
