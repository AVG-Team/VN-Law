import 'package:VNLAW/utils/loading.dart';
import 'package:VNLAW/screens/tree_vbqppl/widgets/pagination_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../api_service/api_service_law.dart';
import '../../data/models/vbqppl/article.dart';
import '../../data/models/vbqppl/chapter.dart';
import '../../data/models/video_loader.dart';

class ArticleScreen extends StatefulWidget {
  final Chapter chapter;

  const ArticleScreen({required this.chapter, super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final ApiServiceLaw _apiService = ApiServiceLaw();
  int _currentPage = 0;
  final int _pageSize = 10;
  int _totalPages = 0;
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _expandedArticles = {};
  late VideoPlayerController _videoController;

  @override
  void initState() {
    _videoController = VideoLoader().controller;
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final result = await _apiService.getArticlesByChapter(
        widget.chapter.id,
        _currentPage,
        _pageSize,
      );

      setState(() {
        _articles = result['articles'];
        _filteredArticles = _articles;
        _totalPages = result['totalPages'];
        _isLoading = false;

        // Set all articles to collapsed by default
        for (var article in _articles) {
          _expandedArticles[article.id] = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  void _filterArticles(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredArticles = _articles;
      } else {
        _filteredArticles = _articles
            .where((article) =>
            article.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
    });
    _loadArticles();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    print('Launching URL: $url');
    print('Launching URL: $uri');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể mở liên kết: $url')),
      );
    }
  }

  void _toggleArticleExpanded(String articleId) {
    setState(() {
      _expandedArticles[articleId] = !(_expandedArticles[articleId] ?? false);
    });
  }

  void _showSummaryNotAvailable() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng tóm tắt đang được phát triển'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm điều luật...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _filterArticles,
        )
            : Text('Điều luật: ${widget.chapter.name.trim()}'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filterArticles('');
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const LoadingWidget()
                : _hasError
                ? Center(child: Text('Đã xảy ra lỗi: $_errorMessage'))
                : _filteredArticles.isEmpty
                ? const Center(child: Text('Không có điều luật nào'))
                : ListView.builder(
              itemCount: _filteredArticles.length,
              itemBuilder: (context, index) {
                final article = _filteredArticles[index];
                final isExpanded = _expandedArticles[article.id] ?? false;

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          article.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(article.vbqppl),
                        trailing: IconButton(
                          icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                          onPressed: () => _toggleArticleExpanded(article.id),
                        ),
                      ),
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.getSummary(),
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: _showSummaryNotAvailable,
                                    child: const Text('Tóm tắt'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => _launchUrl(article.vbqpplLink),
                                    child: const Text(
                                      'Xem chi tiết',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_totalPages > 0 && !_isSearching)
            PaginationWidget(
              currentPage: _currentPage,
              totalPages: _totalPages,
              onPageChanged: _changePage,
            ),
        ],
      ),
    );
  }
}