import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_to_pdf/html_to_pdf.dart';
import 'package:printing/printing.dart';
import 'package:diacritic/diacritic.dart';

import '../../data/models/legal_document.dart';

class DetailScreen extends StatelessWidget {
  final LegalDocument legalDocument;

  const DetailScreen({super.key, required this.legalDocument});

  String createSafeFileName(String? title) {
    if (title == null || title.isEmpty) {
      return 'vanban_${DateTime.now().millisecondsSinceEpoch}';
    }

    return removeDiacritics(title) // Sử dụng package diacritic
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  // Hàm tạo và in PDF
  Future<void> generatePdf(BuildContext context) async {
    try {
      String title = createSafeFileName(legalDocument.title?.trim());
      final pdfFile = await HtmlToPdf.convertFromHtmlContent(
          htmlContent: legalDocument.html ?? '<p>Không có nội dung</p>',
          printPdfConfiguration: PrintPdfConfiguration(
            targetDirectory: '/storage/emulated/0/Download',
            targetName: '$title.pdf',
            printSize: PrintSize.A4,
            printOrientation: PrintOrientation.Portrait,
            linksClickable: true,
          )
      );
      await Printing.layoutPdf(
        onLayout: (format) async => pdfFile.readAsBytes(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tạo PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = (legalDocument.title ?? 'Chi tiết văn bản').trim();
    print("Title detail : " + title);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => generatePdf(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Html(
          data: legalDocument.html ?? '<p>Không có nội dung</p>',
        ),
      ),
    );
  }
}