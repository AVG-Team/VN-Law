import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants/baseUrl.dart';
import '../../models/legalDocument.dart';
import 'documentCard.dart';
import 'documentDetail.dart';

class LegalDocumentScreen extends StatefulWidget {
  const LegalDocumentScreen({super.key});

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen> {
  String _selectedType = 'Tất cả';
  String _searchQuery = '';
  final List<String> _types = [
    'Tất cả',
    'NGHỊ ĐỊNH',
    'QUYẾT ĐỊNH',
    'THÔNG TƯ',
    'CHƯA PHÂN LOẠI'
  ];
  List<LegalDocument> _documents = [];
  bool _isLoading = false;
  String? _error;


  @override
  void initState() {
    super.initState();
    _fetchDocuments();
  }

  Future<void> _fetchDocuments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final queryParams = {
        if (_selectedType != 'Tất cả')
          'type': _selectedType == 'CHƯA PHÂN LOẠI' ? '' : _selectedType,
        if (_searchQuery.isNotEmpty) 'q': _searchQuery,
        'pageSize': '20', // Add the pageSize parameter here (adjust the value as needed)
      };

      final uri = Uri.parse('$baseUrl/law-service/vbqppl').replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));

        setState(() {
          if (jsonData.containsKey('data') && jsonData['data'] is Map) {
            final content = jsonData['data']['content'];
            print(content);
            if (content is List) {
              _documents = content.map<LegalDocument?>((json) {
                try {
                  return LegalDocument.fromJson(json);
                } catch (e) {
                  print('Error parsing document: $e');
                  return null;
                }
              }).whereType<LegalDocument>()
                  .where((doc) => doc.type.isNotEmpty)
                  .toList();
            } else {
              throw Exception('Invalid data format: Expected a list in content');
            }
          } else {
            throw Exception('Invalid data format: ${jsonData}');
          }
          _isLoading = false;
        });
      } else {
        throw Exception('Error fetching data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('Fetch documents error: $e');
    }
  }




  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Danh sách văn bản pháp luật',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(Icons.refresh, color: Colors.white),
            ],
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Xem danh sách các văn bản quy phạm pháp luật',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: _selectedType,
            isExpanded: true,
            underline: const SizedBox(),
            hint: const Text('Tìm kiếm theo thể loại'),
            items: _types.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedType = value;
                });
                _fetchDocuments();
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Tìm kiếm theo từ khóa',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            Future.delayed(const Duration(milliseconds: 500), () {
              if (_searchQuery == value) {
                _fetchDocuments();
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildDocumentList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Đã xảy ra lỗi:\n$_error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchDocuments,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_documents.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy văn bản nào'),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchDocuments,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _documents.length,
        itemBuilder: (context, index) {
          final document = _documents[index];
          return DocumentCard(
            document: document,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DocumentDetailScreen(document: document),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSearchSection(),
                      const SizedBox(height: 16),
                      Expanded(child: _buildDocumentList()),
                    ],
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