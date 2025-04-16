// To parse this JSON data, do
//
//     final responseLogin = responseLoginFromJson(jsonString);

import 'dart:convert';

ResponseLogin responseLoginFromJson(String str) =>
    ResponseLogin.fromJson(json.decode(str));

String responseLoginToJson(ResponseLogin data) => json.encode(data.toJson());

class ResponseLogin {
  ResponseLogin({
    this.result,
    this.message,
    this.data
  });

  bool? result;
  String? message;
  UserModel? data;

  factory ResponseLogin.fromJson(Map<String, dynamic> json) => ResponseLogin(
      result: json["httpStatus"] == "OK",
      message: json["message"],
      data: json["data"] != null ? UserModel.fromJson(json["data"]) : null
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data?.toJson(),
  };
}

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.email,
    this.token,
    this.role,
  });

  String? id;
  String? name;
  String? email;
  String? token;
  String? role;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    token: json["access_token"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "token": token,
    "role": role,
  };

  bool isAdmin() {
    return role == "ADMIN";
  }

  bool isUser() {
    return role == "USER";
  }

  String profileImage() {
    if (role == "ADMIN") {
      return "assets/admin_avatar.png";
    } else {
      return "assets/user_avatar.png";
    }
  }
}
