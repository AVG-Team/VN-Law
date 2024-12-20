import 'package:flutter/material.dart';
import 'package:mobile/screens/news/widgets/news_detail_widget.dart';
import '../../models/news_article.dart';
import '../../services/news_service.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key}); // Make the constructor const

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState(); // Create state
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  late Future<List<NewsArticle>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = NewsService().fetchNewsByPubDay(); // Fetch articles on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // Back button functionality
                    },
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Tin Tức Mới Nhất',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: FutureBuilder<List<NewsArticle>>(
                    future: futureArticles, // Use futureArticles from state
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator()); // Show loading indicator
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}')); // Show error message
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No articles found')); // Show no articles message
                      } else {
                        final articles = snapshot.data!; // Get articles from snapshot data
                        return ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsDetailPage(article: article),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Image.network(
                                          article.imageUrl!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              article.title!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                article.description!),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              article.pubDate!,
                                              style: const TextStyle(
                                                color: Colors.grey,
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
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
