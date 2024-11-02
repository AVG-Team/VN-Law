import 'package:flutter/material.dart';
import '';
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
      final matchesType = _selectedType == 'Tất cả';  doc.type == _selectedType;
      final matchesQuery = _searchQuery.isEmpty;
      doc.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.number.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesType && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
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
                ],
              ),
            ),
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
    );
  }
}
