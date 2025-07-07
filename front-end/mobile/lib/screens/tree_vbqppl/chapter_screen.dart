import 'package:VNLAW/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../api_service/api_service_law.dart';
import '../../data/models/vbqppl/chapter.dart';
import '../../data/models/vbqppl/subject.dart';
import 'article_screen.dart';

class ChapterScreen extends StatefulWidget {
  final Subject subject;

  const ChapterScreen({required this.subject, super.key});

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  final ApiServiceLaw _apiService = ApiServiceLaw();
  late Future<List<Chapter>> _chaptersFuture;
  List<Chapter> _chapters = [];
  List<Chapter> _filteredChapters = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chaptersFuture = _apiService.getChaptersBySubject(widget.subject.id).then((chapters) {
      _chapters = chapters;
      _filteredChapters = chapters;
      return chapters;
    });
  }

  void _filterChapters(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChapters = _chapters;
      } else {
        _filteredChapters = _chapters
            .where((chapter) =>
            chapter.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm chương...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: _filterChapters,
        )
            : Text('Chương: ${widget.subject.name}'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filterChapters('');
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Chapter>>(
        future: _chaptersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có chương nào'));
          } else {
            return ListView.builder(
              itemCount: _filteredChapters.length,
              itemBuilder: (context, index) {
                final chapter = _filteredChapters[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        chapter.index.isNotEmpty ? chapter.index : '${index + 1}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      chapter.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleScreen(chapter: chapter),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}