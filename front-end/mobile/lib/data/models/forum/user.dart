class UserForum {
  int? id;
  String username;
  String email;
  String? password;
  String role;

  UserForum({this.id, required this.username, required this.email, this.password, this.role = 'user'});

  factory UserForum.fromJson(Map<String, dynamic> json) {
    return UserForum(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }
}