import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/constants/base_url.dart';

import '../models/news_article.dart';

class NewsService {
  final String apiKey = 'pub_5837746cab4bf369b544797dc6325342a096c';
  final String baseUrl = 'https://newsdata.io/api/1/latest?country=vi';
  final String urlNotCategory ='https://newsdata.io/api/1/latest?country=vi&apikey=pub_5837746cab4bf369b544797dc6325342a096c';
  Future<List<NewsArticle>> fetchNewsArticles() async {
    final response = await http.get(Uri.parse('$baseUrl&apikey=$apiKey'));

    if (response.statusCode == 200) {
      // Decode the response body as UTF-8
      final utf8Response = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> json = jsonDecode(utf8Response);
      final List<dynamic> results = json['results'];
      return results.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news articles');
    }
  }

  Future<List<NewsArticle>> fetchNewsByPubDay() async {
    final response = await http.get(Uri.parse(urlNotCategory));

    if (response.statusCode == 200) {
      // Decode the response body as UTF-8
      final utf8Response = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> json = jsonDecode(utf8Response);
      final List<dynamic> results = json['results'];

      List<NewsArticle> articles = results
          .map((articleJson) {
        // Check if the articleJson is valid before creating a NewsArticle
        if (articleJson != null && articleJson is Map<String, dynamic>) {
          return NewsArticle.fromJson(articleJson);
        }
        return null; // Return null for invalid articles
      })
          .where((article) => article != null) // Filter out null articles
          .cast<NewsArticle>() // Cast to List<NewsArticle>
          .toList();

      // Sort articles by publication date in descending order
      articles.sort((a, b) => b.pubDate!.compareTo(a.pubDate!));

      // Return only the first 6 articles
      return articles.take(6).toList();
    } else {
      throw Exception('Failed to load news articles');
    }
  }



  Future<List<NewsArticle>> fetchNewsByCategory(String category) async {
    if (category == "Mới nhất") {
      return await fetchNewsByPubDay();
    }
    String convert = convertCategory(category);
    final response = await http.get(
        Uri.parse('$baseUrl&category=$convert&apikey=$apiKey'));

    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> json = jsonDecode(utf8Response);
      final List<dynamic> results = json['results'];

      List<NewsArticle> articles = results.map((article) => NewsArticle.fromJson(article)).toList();

      articles.sort((a, b) {
        return b.pubDate!.compareTo(a.pubDate!); // Sort in descending order
      });

      // Limit to the first 6 articles
      return articles.take(6).toList();
    } else {
      throw Exception('Failed to load news articles');
    }
  }

  String convertCategory(String category) {
    switch (category) {
      case "Pháp luật":
        return 'politics';
      case "Đời sống":
        return 'top';
      case "An Ninh":
        return 'politics';
      default:
        return 'unknown'; // Return a default category or handle it as needed
    }
  }




}
