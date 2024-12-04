// To parse this JSON data, do
//
//     final responseChangePasswordProfile = responseChangePasswordProfileFromJson(jsonString);

import 'dart:convert';

ResponseChangePasswordProfile responseChangePasswordProfileFromJson(
    String str) =>
    ResponseChangePasswordProfile.fromJson(json.decode(str));

String responseChangePasswordProfileToJson(
    ResponseChangePasswordProfile data) =>
    json.encode(data.toJson());

class ResponseChangePasswordProfile {
  ResponseChangePasswordProfile(
      {this.result, this.message, this.data, this.laravelValidationError});

  bool? result;
  String? message;
  Data? data;
  LaravelValidationError? laravelValidationError;

  factory ResponseChangePasswordProfile.fromJson(Map<String, dynamic> json) =>
      ResponseChangePasswordProfile(
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
  final String? currentPassword;
  final String? password;
  final String? passwordConfirmation;

  LaravelValidationError(
      {this.currentPassword, this.password, this.passwordConfirmation});

  factory LaravelValidationError.formjson(Map<String, dynamic> json) {
    return LaravelValidationError(
        currentPassword: json["current_password"] != null
            ? json["current_password"][0]
            : null,
        password: json["password"] != null ? json["password"][0] : null,
        passwordConfirmation: json["password_confirmation"] != null
            ? json["password_confirmation"][0]
            : null);
  }
}
