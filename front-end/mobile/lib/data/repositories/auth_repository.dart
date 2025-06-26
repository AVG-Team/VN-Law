// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
//
// import '../../api_service/api_body.dart';
// import '../../api_service/api_response.dart';
// import '../../api_service/api_service.dart';
// import '../models/auth_response/response_change_password_profile.dart';
// import '../models/auth_response/response_change_passwrod.dart';
// import '../models/auth_response/response_login.dart';
// import '../models/auth_response/response_verification_code.dart';
//
// class AuthRepository {
//   /// Login API -----------------
//   static Future<ApiResponse<ResponseLogin>> getLogin(
//       BodyLogin bodyLogin) async {
//     try {
//       EasyLoading.show(status: 'loading...');
//       var response = await ApiService.getDio()!.post("/api/auth/authenticate", data: bodyLogin);
//       EasyLoading.dismiss();
//       if (response.statusCode == 200) {
//         if (kDebugMode) {
//           print(response.data);
//         }
//         var obj = responseLoginFromJson(response.toString());
//         return ApiResponse(
//             httpCode: response.statusCode,
//             result: obj.result,
//             message: obj.message,
//             data: obj);
//       } else {
//         var obj = responseLoginFromJson(response.toString());
//         return ApiResponse(
//             httpCode: response.statusCode,
//             result: obj.result,
//             message: obj.message,
//             data: obj);
//       }
//     } on DioException catch (e) {
//       if (e.type == DioExceptionType.badResponse) {
//         EasyLoading.dismiss();
//         var obj = responseLoginFromJson(e.response.toString());
//
//         return ApiResponse(
//           httpCode: e.response!.statusCode,
//           result: e.response!.data["result"],
//           message: e.response!.data["message"],
//           error: obj,
//         );
//       } else {
//         EasyLoading.dismiss();
//         if (kDebugMode) {
//           print(e.message);
//         }
//         return ApiResponse(
//             httpCode: -1, message: "Connection error ${e.message}");
//       }
//     }
//   }
//
//   /// Forget Password API -----------------
//   static Future<ApiResponse<ResponseVerificationCode>> getVerificationCode(
//       BodyVerificationCode bodyVerificationCode) async {
//     try {
//       EasyLoading.show(status: 'loading...');
//       var response = await ApiService.getDio()!
//           .post("/reset-password", data: bodyVerificationCode);
//       EasyLoading.dismiss();
//       if (response.statusCode == 200) {
//         if (kDebugMode) {
//           print(response.data);
//         }
//         var obj = responseVerificationCodeFromJson(response.toString());
//         return ApiResponse(
//             httpCode: response.statusCode,
//             result: obj.result,
//             message: obj.message,
//             data: obj);
//       } else {
//         var obj = responseVerificationCodeFromJson(response.toString());
//         return ApiResponse(
//             httpCode: response.statusCode,
//             result: obj.result,
//             message: obj.message,
//             data: obj);
//       }
//     } on DioException catch (e) {
//       if (e.type == DioExceptionType.badResponse) {
//         EasyLoading.dismiss();
//         var obj = responseVerificationCodeFromJson(e.response.toString());
//         return ApiResponse(
//             httpCode: e.response!.statusCode,
//             result: e.response!.data["result"],
//             message: e.response!.data["message"],
//             error: obj);
//       } else {
//         EasyLoading.dismiss();
//         if (kDebugMode) {
//           print(e.message);
//         }
//         return ApiResponse(
//             httpCode: -1, message: "Connection error ${e.message}");
//       }
//     }
//   }
//
//   /// Change Password API -----------------
//   static Future<ApiResponse<ResponseChangePassword>> getChangePassword(
//       BodyChangePassword bodyResetPassword) async {
//     try {
//       EasyLoading.show(status: 'loading...');
//       var response = await ApiService.getDio()!
//           .post("/change-password", data: bodyResetPassword);
//       EasyLoading.dismiss();
//       if (response.statusCode == 200) {
//         if (kDebugMode) {
//           print(response.data);
//         }
//         var obj = responseChangePasswordFromJson(response.toString());
//         return ApiResponse(
//             httpCode: response.statusCode,
//             result: obj.result,
//             message: obj.message,
//             data: obj);
//       } else {
//         var obj = responseChangePasswordFromJson(response.toString());
//         return ApiResponse(
//             httpCode: response.statusCode,
//             result: obj.result,
//             message: obj.message,
//             data: obj);
//       }
//     } on DioException catch (e) {
//       if (e.type == DioExceptionType.badResponse) {
//         EasyLoading.dismiss();
//         var obj = responseChangePasswordFromJson(e.response.toString());
//         return ApiResponse(
//             httpCode: e.response!.statusCode,
//             result: e.response!.data["result"],
//             message: e.response!.data["message"],
//             error: obj);
//       } else {
//         EasyLoading.dismiss();
//         if (kDebugMode) {
//           print(e.message);
//         }
//         return ApiResponse(
//             httpCode: -1, message: "Connection error ${e.message}");
//       }
//     }
//   }
//
//   /// ChangePasswordProfile API -----------------
//   static Future<ApiResponse<ResponseChangePasswordProfile>>
//   getChangePasswordProfile(
//       BodyChangePasswordProfile bodyChangePasswordProfile) async {
//     try {
//       EasyLoading.show(status: 'loading...');
//       var response = await ApiService.getDio()!
//           .post("/user/password-update", data: bodyChangePasswordProfile);
//       EasyLoading.dismiss();
//       if (response.statusCode == 200) {
//         if (kDebugMode) {
//           print(response.data);
//         }
//         var obj = responseChangePasswordProfileFromJson(response.toString());
//         return ApiResponse(
//             httpCode: response.statusCode,
//             result: obj.result,
//             message: obj.message,
//             data: obj);
//       } else {
//         var obj = responseChangePasswordProfileFromJson(response.toString());
//         return ApiResponse(
//             httpCode: response.statusCode,
//             result: obj.result,
//             message: obj.message,
//             data: obj);
//       }
//     } on DioException catch (e) {
//       if (e.type == DioExceptionType.badResponse) {
//         EasyLoading.dismiss();
//         var obj = responseChangePasswordProfileFromJson(e.response.toString());
//         return ApiResponse(
//             httpCode: e.response!.statusCode,
//             result: e.response!.data["result"],
//             message: e.response!.data["message"],
//             error: obj);
//       } else {
//         if (kDebugMode) {
//           print(e.message);
//         }
//         return ApiResponse(
//             httpCode: -1, message: "Connection error ${e.message}");
//       }
//     }
//   }
// }
