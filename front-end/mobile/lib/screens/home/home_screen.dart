import 'package:flutter/material.dart';
import 'package:mobile/screens/chat/home_page_chat_screen.dart';
import 'package:mobile/screens/profile_screen.dart';
import 'package:mobile/screens/home/widgets/_build_news_card.dart';
import 'package:mobile/screens/home/widgets/_build_news_tag.dart';
import 'package:mobile/screens/home/widgets/_build_service_Icon.dart';
import 'package:mobile/screens/legal_document/legal_document_screen.dart';
import 'package:mobile/screens/news/news_screen.dart';
import 'package:mobile/screens/news/widgets/news_detail_widget.dart';
import 'package:mobile/screens/vbql/vbpl_screen.dart';
import '../../models/news_article.dart';
import '../../services/news_service.dart';
import 'widgets/_build_service_category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSidebarOpen = false;
  String selectedNewsTag = 'Mới nhất';
  Color selectedColor = Colors.lightBlueAccent;

  late Future<List<NewsArticle>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = NewsService().fetchNewsByCategory(selectedNewsTag);
  }

  void _handleNewsTagTap(String tag) {
    setState(() {
      selectedNewsTag = tag;
      futureArticles = NewsService().fetchNewsByCategory(selectedNewsTag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/logo.png', width: 120),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_none, color: Colors.blueAccent),
                          onPressed: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome 👋',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Text(
                          'Nếu bạn cần trợ giúp về pháp luật?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Service Categories
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ServiceCategory(
                              title: 'Tra Cứu\nPháp Luật',
                              icon: Icons.search_rounded,
                              bgColor: Colors.red[50]!,
                              iconColor: Colors.red,
                              destination: const VbplScreen(),
                            ),
                            ServiceCategory(
                              title: 'Chatbot\nPháp Luật',
                              icon: Icons.wechat_outlined,
                              bgColor: Colors.orange[50]!,
                              iconColor: Colors.orange,
                              destination: const HomePageChatScreen(),
                            ),
                            ServiceCategory(
                              title: 'Văn Bản\nPháp Luật',
                              icon: Icons.document_scanner_outlined,
                              bgColor: Colors.blue[50]!,
                              iconColor: Colors.blue,
                              destination: const LegalDocumentScreen(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // News Section
                        const Text(
                          'Tin tức hằng ngày',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // News Tags
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              NewsTag(
                                text: 'Mới nhất',
                                color: selectedNewsTag == "Mới nhất" ? Colors.lightBlueAccent : Colors.grey[500]!,
                                onTap: _handleNewsTagTap,
                              ),
                              NewsTag(
                                text: 'Pháp luật',
                                color: selectedNewsTag == "Pháp luật" ? Colors.lightBlueAccent : Colors.grey[500]!,
                                onTap: _handleNewsTagTap,
                              ),
                              NewsTag(
                                text: 'Đời sống',
                                color: selectedNewsTag == "Đời sống" ? Colors.lightBlueAccent : Colors.grey[500]!,
                                onTap: _handleNewsTagTap,
                              ),
                              NewsTag(
                                text: 'An Ninh',
                                color: selectedNewsTag == "An Ninh" ? Colors.lightBlueAccent : Colors.grey[500]!,
                                onTap: _handleNewsTagTap,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        FutureBuilder<List<NewsArticle>>(
                          future: futureArticles,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No news articles available.'));
                            } else {
                              return SizedBox(
                                height: 170,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: snapshot.data!.map((article) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: GestureDetector( // Use GestureDetector to handle taps
                                          onTap: () {
                                            // Navigate to NewsDetailPage on tap
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => NewsDetailPage(article: article),
                                              ),
                                            );
                                          },
                                          child: NewsCard(
                                            title: article.title ?? 'N/A',
                                            category: (article.category.isNotEmpty) ? article.category[0] : 'No description',
                                            sourceName: article.sourceName ?? 'Unknown Source',
                                            urlImage: article.imageUrl,
                                            color: Colors.green,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 24),

                        // Other Services
                        const Text(
                          'Các Dịch Vụ Khác',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Service Icons
                        const SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ServiceIcon(
                                icon: Icons.forum_outlined,
                                color: Colors.green,
                                destination: VbplScreen(),
                              ),
                              SizedBox(width: 24),
                              ServiceIcon(
                                icon: Icons.newspaper_outlined,
                                color: Colors.blue,
                                destination: NewsFeedPage(),
                              ),
                              SizedBox(width: 24),
                              ServiceIcon(
                                icon: Icons.info_outline,
                                color: Colors.purple,
                                destination: ProfileScreen(),
                              ),
                              SizedBox(width: 24),
                              ServiceIcon(
                                icon: Icons.search_outlined,
                                color: Colors.red,
                                destination: VbplScreen(),
                              ),
                              SizedBox(width: 24),
                              ServiceIcon(
                                icon: Icons.wechat_outlined,
                                color: Colors.orange,
                                destination: HomePageChatScreen(),
                              ),
                              SizedBox(width: 24),
                              ServiceIcon(
                                icon: Icons.document_scanner_outlined,
                                color: Colors.pink,
                                destination: LegalDocumentScreen(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
