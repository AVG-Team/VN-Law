import 'dart:math';

class LegalDocument {
  final int id;
  final String type;
  final String number;
  final String title;
  final String organization;
  final String date;
  final String htmlContent;

  LegalDocument({
    required this.id,
    String? type,
    required this.number,
    required this.title,
    String? organization,
    required this.date,
    required this.htmlContent,
  }) :
        type = type ?? 'CHƯA PHÂN LOẠI',
        organization = organization ?? _randomOrganization();

  factory LegalDocument.fromJson(Map<String, dynamic> json) {
    return LegalDocument(
      id: json['id'] ?? 0,
      type: json['type'],
      number: json['number'] ?? '',
      title: json['title'] ?? 'Văn bản pháp luật Việt Nam',
      organization: json['organization'],
      date: json['date'] ?? '',
      htmlContent: json['html'] ?? '',
    );
  }

  static String _randomOrganization() {
    final organizations = [
      'Chính Phủ', 'Bộ Công An', 'Bộ Tài Chính', 'Quốc Hội',
      'UBND Hà Nội', 'UBND TP Hồ Chí Minh', 'Bộ Tư Pháp',
      'Sở Y Tế', 'Sở Giáo Dục', 'Bộ Khoa Học và Công Nghệ'
    ];
    final randomIndex = Random().nextInt(organizations.length);
    return organizations[randomIndex];
  }
}
