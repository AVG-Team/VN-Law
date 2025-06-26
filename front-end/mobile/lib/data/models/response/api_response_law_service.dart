import '../legal_document.dart';

class ApiResponse {
  final List<LegalDocument> content;
  final int totalElements;
  final int totalPages;
  final int number;
  final int size;

  ApiResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.number,
    required this.size,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var contentList = json['data']['content'] as List;
    List<LegalDocument> documents = contentList.map((i) => LegalDocument.fromJson(i)).toList();
    print(json.toString());
    return ApiResponse(
      content: documents,
      totalElements: json['data']['totalElements'] as int? ?? 0,
      totalPages: json['data']['totalPages'] as int? ?? 0,
      number: json['data']['number'] as int? ?? 0,
      size: json['data']['size'] as int? ?? 0,
    );
  }
}