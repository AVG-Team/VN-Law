import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../data/models/news_response/response_news.dart';
import '../../data/repositories/news_repository.dart';

class NewsProvider extends ChangeNotifier {
  Future<List<NewsArticle>> getNewsArticles() async {
    var apiResponse = await NewsRepository.getNewsArticles();

    if (apiResponse.result == true) {
      List<NewsArticle> articles = apiResponse.data!.data ?? [];

      Fluttertoast.showToast(
          msg: "Get News Articles Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0
      );

      return articles;
    } else {
      throw Exception('Failed to load news articles');
    }
  }

  Future<List<NewsArticle>> getNewsByPubDay() async {
    var apiResponse = await NewsRepository.getNewsArticles();

    if (apiResponse.result == true) {
      List<NewsArticle> articles = apiResponse.data!.data ?? [];

      articles.where((article) => article.title != null && article.title!.isNotEmpty)
          .take(6)
          .toList();

      Fluttertoast.showToast(
          msg: "Get News Articles Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0
      );

      return articles;
    } else {
      throw Exception('Failed to load news articles');
    }
  }

  Future<List<NewsArticle>> getNewsByCategory(String category) async {
    if (category == "Mới nhất") {
      return await getNewsByPubDay();
    }
    var apiResponse = await NewsRepository.getNewsArticles(category: category);

    if (apiResponse.result == true) {
      List<NewsArticle> articles = apiResponse.data!.data ?? [];
      articles.sort((a, b) {
        return b.pubDate!.compareTo(a.pubDate!); // Sort in descending order
      });
      return articles.take(6).toList();
    } else {
      throw Exception('Failed to load news articles');
    }
  }
}