// To parse this JSON data, do
//
//     final responseChangePassword = responseChangePasswordFromJson(jsonString);

import 'dart:convert';

ResponseChangePassword responseChangePasswordFromJson(String str) =>
    ResponseChangePassword.fromJson(json.decode(str));

String responseChangePasswordToJson(ResponseChangePassword data) =>
    json.encode(data.toJson());

class ResponseChangePassword {
  ResponseChangePassword(
      {this.result, this.message, this.data, this.laravelValidationError});

  bool? result;
  String? message;
  Data? data;
  LaravelValidationError? laravelValidationError;

  factory ResponseChangePassword.fromJson(Map<String, dynamic> json) =>
      ResponseChangePassword(
          result: json["result"],
          message: json["message"],
          data: json["data"] != null ? Data.fromJson(json["data"]) : null,
          laravelValidationError: json["error"] != null
              ? LaravelValidationError.formjson(json["error"])
              : null);

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}

class LaravelValidationError {
  final String? email;
  final String? code;
  final String? password;
  final String? passwordConfirmation;

  LaravelValidationError(
      {this.email, this.code, this.password, this.passwordConfirmation});

  factory LaravelValidationError.formjson(Map<String, dynamic> json) {
    return LaravelValidationError(
        email: json["email"] != null ? json["email"][0] : null,
        code: json["code"] != null ? json["code"][0] : null,
        password: json["password"] != null ? json["password"][0] : null,
        passwordConfirmation: json["password_confirmation"] != null
            ? json["password_confirmation"][0]
            : null);
  }
}
