import 'dart:ffi';

class Subject {
  final String id;
  final String name;
  final Int order;

  Subject({required this.id, required this.name, required this.order});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
        id: json['id'],
        name: json['name'],
        order: json['order']
    );
  }
}