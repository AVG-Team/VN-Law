import 'package:flutter/material.dart';
import '../../models/legal_document.dart';
import 'document_card.dart';
import 'document_detail.dart';

class LegalDocumentScreen extends StatefulWidget {
  const LegalDocumentScreen({super.key});

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen> {
  String _selectedType = 'Tất cả';
  String _searchQuery = '';
  final List<String> _types = ['Tất cả', 'NGHỊ ĐỊNH', 'QUYẾT ĐỊNH', 'THÔNG TƯ'];

  // Sample data
  final List<LegalDocument> _documents = [
    LegalDocument(
      id: '1',
      type: 'NGHỊ ĐỊNH',
      number: '20/2016/NĐ-CP',
      title: 'Quy định cơ sở dữ liệu quốc gia về xử lý vi phạm hành chính',
      organization: 'CHÍNH PHỦ',
      date: 'Hà Nội, ngày 30 tháng 3 năm 2016',
      htmlContent: '<html>...</html>',
    ),
    // Add more documents...
  ];

  List<LegalDocument> get filteredDocuments {
    return _documents.where((doc) {
      final matchesType = _selectedType == 'Tất cả' || doc.type == _selectedType;
      final matchesQuery = _searchQuery.isEmpty ||
          doc.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.number.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesType && matchesQuery;
    }).toList();
  }

  // void _refreshDocuments() {
  //   // Implement your logic to refresh the documents here
  //   // For example, you can fetch new data from an API
  //   setState(() {
  //     // If you need to reset or refresh the documents, do it here
  //     // _documents.clear(); // Clear existing documents if necessary
  //     // Fetch new documents and add them to _documents
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
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
                      Icon(Icons.refresh, color: Colors.white), // Refresh icon
                    ],
                  ),
                  SizedBox(height: 24),
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
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
                            setState(() {
                              _selectedType = value!;
                            });
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
                        },
                      ),
                      const SizedBox(height: 8), // Add spacing after the TextField
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: filteredDocuments.length,
                          itemBuilder: (context, index) {
                            final document = filteredDocuments[index];
                            return DocumentCard(
                              document: document,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DocumentDetailScreen(
                                      document: document,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
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
