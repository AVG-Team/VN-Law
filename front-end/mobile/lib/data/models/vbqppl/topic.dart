// topic.dart
class Topic {
  final String id;
  final String name;
  final int order;

  Topic({required this.id, required this.name, required this.order});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      name: json['name'],
      order: json['order'],
    );
  }
}