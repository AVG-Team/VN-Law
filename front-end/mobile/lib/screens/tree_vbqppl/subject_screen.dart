import 'package:VNLAW/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../api_service/api_service_law.dart';
import '../../data/models/vbqppl/subject.dart';
import '../../data/models/vbqppl/topic.dart';
import 'chapter_screen.dart';

class SubjectScreen extends StatefulWidget {
  final Topic topic;

  const SubjectScreen({required this.topic, super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final ApiServiceLaw _apiService = ApiServiceLaw();
  late Future<List<Subject>> _subjectsFuture;
  List<Subject> _subjects = [];
  List<Subject> _filteredSubjects = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subjectsFuture = _apiService.getSubjectsByTopic(widget.topic.id).then((subjects) {
      _subjects = subjects;
      _filteredSubjects = subjects;
      return subjects;
    });
  }

  void _filterSubjects(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSubjects = _subjects;
      } else {
        _filteredSubjects = _subjects
            .where((subject) =>
            subject.name.toLowerCase().contains(query.toLowerCase()))
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
            hintText: 'Tìm kiếm chủ đề...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: _filterSubjects,
        )
            : Text('Chủ đề: ${widget.topic.name}'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filterSubjects('');
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Subject>>(
        future: _subjectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có chủ đề nào'));
          } else {
            return ListView.builder(
              itemCount: _filteredSubjects.length,
              itemBuilder: (context, index) {
                final subject = _filteredSubjects[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        '${subject.order}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      subject.name,
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
                          builder: (context) => ChapterScreen(subject: subject),
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