import 'package:VNLAW/screens/home/widgets/_build_news_card.dart';
import 'package:VNLAW/screens/home/widgets/_build_news_tag.dart';
import 'package:VNLAW/screens/home/widgets/_build_service_Icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api_service/connectivity/no_internet_screen.dart';
import '../../data/models/news_response/response_news.dart';
import '../news/news_detail_widget.dart';
import '../news/news_provider.dart';
import '../screen_tmp.dart';
import 'home_provider.dart';
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
  final NewsProvider _newsProvider = NewsProvider();

  @override
  void initState() {
    super.initState();
    futureArticles = _newsProvider.getNewsByCategory(selectedNewsTag);
  }

  void _handleNewsTagTap(String tag) {
    setState(() {
      selectedNewsTag = tag;
      futureArticles = _newsProvider.getNewsByCategory(selectedNewsTag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NoInternetScreen(
      child: Scaffold(
        backgroundColor: Colors.blue[600],
        key: context.watch<HomeProvider>().scaffoldKey,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Hero(
                          tag: 'logo',
                          child: Image.asset('assets/logo.png', width: 120),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications_none, color: Colors.blue),
                            onPressed: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome 👋',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Text(
                            'Nếu bạn cần trợ giúp về pháp luật?',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Service Categories with animation
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ServiceCategory(
                                  title: 'Tra Cứu\nPháp Luật',
                                  icon: Icons.search_rounded,
                                  bgColor: Colors.red[50]!,
                                  iconColor: Colors.red,
                                  destination: const MyHomePage(title: "Tra cứu pháp luật"),
                                ),
                                ServiceCategory(
                                  title: 'Chatbot\nPháp Luật',
                                  icon: Icons.wechat_outlined,
                                  bgColor: Colors.orange[50]!,
                                  iconColor: Colors.orange,
                                  destination: const MyHomePage(title: "Chatbot pháp luật"),
                                ),
                                ServiceCategory(
                                  title: 'Văn Bản\nPháp Luật',
                                  icon: Icons.document_scanner_outlined,
                                  bgColor: Colors.blue[50]!,
                                  iconColor: Colors.blue,
                                  destination: const MyHomePage(title: "Văn bản pháp luật"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // News Section with enhanced styling
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tin tức hằng ngày',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Add view all news action
                                },
                                child: Text(
                                  'Xem tất cả',
                                  style: TextStyle(
                                    color: Colors.blue[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // News Tags with enhanced animation
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                NewsTag(
                                  text: 'Mới nhất',
                                  color: selectedNewsTag == "Mới nhất" ? Colors.blue[600]! : Colors.grey[400]!,
                                  onTap: _handleNewsTagTap,
                                ),
                                NewsTag(
                                  text: 'Pháp luật',
                                  color: selectedNewsTag == "Pháp luật" ? Colors.blue[600]! : Colors.grey[400]!,
                                  onTap: _handleNewsTagTap,
                                ),
                                NewsTag(
                                  text: 'Đời sống',
                                  color: selectedNewsTag == "Đời sống" ? Colors.blue[600]! : Colors.grey[400]!,
                                  onTap: _handleNewsTagTap,
                                ),
                                NewsTag(
                                  text: 'An Ninh',
                                  color: selectedNewsTag == "An Ninh" ? Colors.blue[600]! : Colors.grey[400]!,
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

                          const SizedBox(height: 32),

                          // Other Services with enhanced styling
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Các Dịch Vụ Khác',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Add view all services action
                                },
                                child: Text(
                                  'Xem tất cả',
                                  style: TextStyle(
                                    color: Colors.blue[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Service Icons with enhanced animation
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildAnimatedServiceIcon(
                                  Icons.forum_rounded,
                                  Colors.green,
                                  const MyHomePage(title: "VBQL Screen"),
                                ),
                                const SizedBox(width: 24),
                                _buildAnimatedServiceIcon(
                                  Icons.newspaper_rounded,
                                  Colors.blue,
                                  const MyHomePage(title: "Tin tức"),
                                ),
                                const SizedBox(width: 24),
                                _buildAnimatedServiceIcon(
                                  Icons.info_rounded,
                                  Colors.purple,
                                  const MyHomePage(title: "Thông tin"),
                                ),
                                const SizedBox(width: 24),
                                _buildAnimatedServiceIcon(
                                  Icons.search_rounded,
                                  Colors.red,
                                  const MyHomePage(title: "Tra cứu"),
                                ),
                                const SizedBox(width: 24),
                                _buildAnimatedServiceIcon(
                                  Icons.wechat_rounded,
                                  Colors.orange,
                                  const MyHomePage(title: "Chatbot"),
                                ),
                                const SizedBox(width: 24),
                                _buildAnimatedServiceIcon(
                                  Icons.document_scanner_rounded,
                                  Colors.pink,
                                  const MyHomePage(title: "Văn bản"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedServiceIcon(IconData icon, Color color, Widget destination) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 1, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: ServiceIcon(
            icon: icon,
            color: color,
            destination: destination,
          ),
        );
      },
    );
  }
}
