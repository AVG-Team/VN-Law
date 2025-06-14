import 'dart:convert';
import '../../utils/shared_preferences.dart';

class UserInfo {
  final String name;
  final String email;
  final String profileImage;
  final String accessToken;
  final String refreshToken;
  final String userRole;

  UserInfo({
    this.name = '',
    this.email = '',
    this.profileImage = '',
    this.accessToken = '',
    this.refreshToken = '',
    this.userRole = 'User',
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      userRole: json['userRole'] as String? ?? 'User',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'profileImage': profileImage,
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'userRole': userRole,
  };

  static Future<UserInfo> initialize() async {
    final name = await SPUtill.getValue(SPUtill.keyName) ?? '';
    final email = await SPUtill.getValue(SPUtill.keyEmail) ?? '';
    final profileImage = await SPUtill.getValue(SPUtill.keyProfileImage) ?? '';
    final accessToken = await SPUtill.getValue(SPUtill.keyAccessToken) ?? '';
    final refreshToken = await SPUtill.getValue(SPUtill.keyRefreshToken) ?? '';
    final rolesJson = await SPUtill.getValue(SPUtill.keyRoles);

    final roles = rolesJson != null ? List<String>.from(jsonDecode(rolesJson)) : [];
    final userRole = roles.contains('admin') ? 'Admin' : 'User';

    return UserInfo(
      name: name,
      email: email,
      profileImage: profileImage,
      accessToken: accessToken,
      refreshToken: refreshToken,
      userRole: userRole,
    );
  }
}