class Post {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final String keycloakId;
  late final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  late int likes;
  late int commentsCount;
  final List<Comment> comments;
  final bool isAdmin;
  bool isLiked = false;
  bool isStarred = false;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.keycloakId,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    required this.likes,
    required this.commentsCount,
    required this.isAdmin,
    this.comments = const [],
    this.isLiked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    print("Post.fromJson: $json");
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      authorName: json['name'],
      keycloakId: json['keycloak_id'],
      isPinned: json['is_pinned'] == 1 ? true : false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      likes: json['likes'] is String ? int.parse(json['likes']) : json['likes'] as int,
      isAdmin: json['is_admin'] ?? false,
      commentsCount: json['commentsCount'] is String ? int.parse(json['commentsCount']) : json['commentsCount'] as int,
      comments: json['comments'] != null
          ? (json['comments'] as List<dynamic>)
          .map((c) => Comment.fromJson(c as Map<String, dynamic>))
          .toList()
          : [],
    );
  }
}

class Comment {
  final int id;
  final String postId;
  final String content;
  final String authorName;
  final String keycloakId;
  final int? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isAdmin;

  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.authorName,
    required this.keycloakId,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
    required this.isAdmin,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    print("parent_id : ${json['parent_id']}");
    return Comment(
      id: json['id'],
      postId: json['post_id'],
      content: json['content'],
      authorName: json['name'],
      keycloakId: json['keycloak_id'],
      parentId: json['parent_id'] == null
          ? null
          : (
          json['parent_id'] is String
          ? int.parse(json['parent_id'])
          : json['parent_id'] as int
          ),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isAdmin: json['is_admin'] ?? false,
    );
  }
}