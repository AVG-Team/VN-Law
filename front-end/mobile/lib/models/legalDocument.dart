class LegalDocument {
  final String id;
  final String type; // NGHI DINH, QUYET DINH, THONG TU
  final String number;
  final String title;
  final String organization;
  final String date;
  final String htmlContent;

  LegalDocument({
    required this.id,
    required this.type,
    required this.number,
    required this.title,
    required this.organization,
    required this.date,
    required this.htmlContent,
  });
}