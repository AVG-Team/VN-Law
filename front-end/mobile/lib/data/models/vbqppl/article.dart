class Article {
  final String id;
  final String name;
  final String content;
  final String index;
  final int? order;
  final String vbqppl;
  final String vbqpplLink;
  final List<dynamic> tables;
  final List<dynamic> files;

  Article({
    required this.id,
    required this.name,
    required this.content,
    required this.index,
    this.order,
    required this.vbqppl,
    required this.vbqpplLink,
    required this.tables,
    required this.files,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      name: json['name'],
      content: json['content'] ?? '',
      index: json['index'] ?? '',
      order: json['order'],
      vbqppl: json['vbqppl'] ?? '',
      vbqpplLink: json['vbqpplLink'] ?? '',
      tables: json['tables'] ?? [],
      files: json['files'] ?? [],
    );
  }

  String getSummary() {
    if (content.length > 600) {
      return '${content.substring(0, 600)}...';
    }
    return content;
  }
}
