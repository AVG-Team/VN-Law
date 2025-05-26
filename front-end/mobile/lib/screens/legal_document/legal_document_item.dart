import 'package:flutter/material.dart';
import '../../data/models/legal_document.dart';
import 'legal_document_detail.dart';

class LegalDocumentItem extends StatelessWidget {
  final LegalDocument legalDocument;

  const LegalDocumentItem({super.key, required this.legalDocument});

  // Hàm loại bỏ ký tự đặc biệt
  String cleanString(String input) {
    return input.replaceAll(RegExp(r'[\r\n\t]'), ' ').trim();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Điều hướng đến DetailScreen với dữ liệu legalDocument
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(legalDocument: legalDocument),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Loại: Sử dụng title làm nổi bật
              Text(
                'Loại: ${cleanString(legalDocument.type ?? 'N/A !!!')}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 4),
              Text('Ngày ban hành: ${cleanString(legalDocument.issueDate ?? 'N/A')}'),
              Text('Cơ quan ban hành: ${cleanString(legalDocument.issuer ?? 'N/A')}'),
              Text('Số hiệu: ${cleanString(legalDocument.number ?? 'N/A')}'),
              Text('Hiệu lực: ${cleanString(legalDocument.effectiveDate ?? 'N/A')}'),
              // Tình trạng hiệu lực: Xanh lá nếu còn, đỏ nếu hết
              Text(
                legalDocument.effectiveEndDate == null ? 'Còn hiệu lực' : 'Hết hiệu lực',
                style: TextStyle(
                  color: legalDocument.effectiveEndDate == null ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}