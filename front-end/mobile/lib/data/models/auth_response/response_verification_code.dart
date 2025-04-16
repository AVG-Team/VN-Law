// To parse this JSON data, do
//
//     final responseVerificationCode = responseVerificationCodeFromJson(jsonString);

import 'dart:convert';

ResponseVerificationCode responseVerificationCodeFromJson(String str) =>
    ResponseVerificationCode.fromJson(json.decode(str));

String responseVerificationCodeToJson(ResponseVerificationCode data) =>
    json.encode(data.toJson());

class ResponseVerificationCode {
  ResponseVerificationCode(
      {this.result, this.message, this.data, this.laravelValidationError});

  bool? result;
  String? message;
  Data? data;
  LaravelValidationError? laravelValidationError;

  factory ResponseVerificationCode.fromJson(Map<String, dynamic> json) =>
      ResponseVerificationCode(
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

  LaravelValidationError({this.email});

  factory LaravelValidationError.formjson(Map<String, dynamic> json) {
    return LaravelValidationError(
        email: json["email"] != null ? json["email"][0] : null);
  }
}
