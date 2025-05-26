class Chapter {
  final String id;
  final String name;
  final String index;
  final int order;

  Chapter({
    required this.id,
    required this.name,
    required this.index,
    required this.order
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      name: json['name'],
      index: json['index'] ?? '',
      order: json['order'],
    );
  }
}
