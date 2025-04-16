import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../api_service/api_body.dart';
import '../../api_service/api_response.dart';
import '../../api_service/api_service.dart';
import '../models/response/response_attendance_status.dart';
import '../models/response/response_base_settings.dart';
// import 'package:vmoffice/api_service/api_body.dart';
// import 'package:vmoffice/api_service/api_response.dart';
// import 'package:vmoffice/api_service/api_service.dart';
// import 'package:vmoffice/data/model/attendance_daily_report.dart';
// import 'package:vmoffice/data/model/auth_response/response_verification_code.dart';
// import 'package:vmoffice/data/model/notifications/read_notification.dart';
// import 'package:vmoffice/data/model/response_all_contents.dart';
// import 'package:vmoffice/data/model/response_all_leave_request.dart';
// import 'package:vmoffice/data/model/response_all_leave_request_details.dart';
// import 'package:vmoffice/data/model/response_all_user.dart';
// import 'package:vmoffice/data/model/response_appreciate_list.dart';
// import 'package:vmoffice/data/model/response_approval_details.dart';
// import 'package:vmoffice/data/model/response_approval_list.dart';
// import 'package:vmoffice/data/model/response_approval_or_reject.dart';
// import 'package:vmoffice/data/model/response_attendace_status.dart';
// import 'package:vmoffice/data/model/response_attendance_report.dart';
// import 'package:vmoffice/data/model/response_base_settings.dart';
// import 'package:vmoffice/data/model/response_break_history.dart';
// import 'package:vmoffice/data/model/response_break_report.dart';
// import 'package:vmoffice/data/model/response_change_status.dart';
// import 'package:vmoffice/data/model/response_check_in.dart';
// import 'package:vmoffice/data/model/response_check_out.dart';
// import 'package:vmoffice/data/model/response_clear_notification.dart';
// import 'package:vmoffice/data/model/response_create_appreciate.dart';
// import 'package:vmoffice/data/model/response_create_leave_request.dart';
// import 'package:vmoffice/data/model/response_create_visit.dart';
// import 'package:vmoffice/data/model/response_create_visit_note.dart';
// import 'package:vmoffice/data/model/response_image_upload_visit.dart';
// import 'package:vmoffice/data/model/response_leave_summary.dart';
// import 'package:vmoffice/data/model/response_leave_type.dart';
// import 'package:vmoffice/data/model/response_location.dart';
// import 'package:vmoffice/data/model/response_meeting_details.dart';
// import 'package:vmoffice/data/model/response_meeting_list.dart';
// import 'package:vmoffice/data/model/response_notice_create.dart';
// import 'package:vmoffice/data/model/response_notice_details.dart';
// import 'package:vmoffice/data/model/response_notice_list.dart';
// import 'package:vmoffice/data/model/response_profile_image.dart';
// import 'package:vmoffice/data/model/response_support_create.dart';
// import 'package:vmoffice/data/model/response_support_details.dart';
// import 'package:vmoffice/data/model/response_support_ticket_list.dart';
// import 'package:vmoffice/data/model/response_user_search.dart';
// import 'package:vmoffice/data/model/response_visit_details.dart';
// import 'package:vmoffice/data/model/response_visit_history.dart';
// import 'package:vmoffice/data/model/response_visit_list.dart';
// import 'package:vmoffice/data/model/resposne_break.dart';
// import 'package:vmoffice/data/model/task/task_details_model.dart';
// import 'package:vmoffice/data/model/task/task_list_model.dart';
//
// import '../../model/notifications/notifications_model.dart';
// import '../../model/reponse_phonebook_details.dart';
// import '../../model/task/task_dashboard_model.dart';

class Repository {
  /// /////////////////////////////////////// LEAVE API START ////////////////////////////////////////////////////////

  /// Leave summary API -----------------
  // static Future<ApiResponse<ResponseLeaveSummary>> leaveSummary(
  //     BodyUserId bodyUserId) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/user/leave/summary", data: bodyUserId);
  //
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseLeaveSummaryFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseLeaveSummaryFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// LEAVE TYPE API -----------------
  // static Future<ApiResponse<ResponseLeaveType>> leaveTypeApi(
  //     BodyUserId bodyUserId) async {
  //   if (kDebugMode) {
  //     print(bodyUserId);
  //   }
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/user/leave/available", data: bodyUserId);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseLeaveTypeFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseLeaveTypeFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = responseLeaveTypeFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// ALL LEAVE REQUEST LIST API -----------------
  // static Future<ApiResponse<ResponseAllLeaveRequest>> allLeaveRequest(
  //     BodyLeaveRequest bodyLeaveRequest) async {
  //   if (kDebugMode) {
  //     print(bodyLeaveRequest.toJson());
  //   }
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/user/leave/list/view", data: bodyLeaveRequest);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = ResponseAllLeaveRequest.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = ResponseAllLeaveRequest.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = ResponseAllLeaveRequest.fromJson(
  //           json.decode(e.response.toString()));
  //       // var obj = responseLeaveTypeFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// ALL LEAVE REQUEST DETAILS SCREEN API -----------------
  // static Future<ApiResponse<ResponseLeaveRequestDetails>> leaveRequestDetails(
  //     BodyUserId bodyUserId, requestId) async {
  //   if (kDebugMode) {
  //     print(bodyUserId.toJson());
  //   }
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/user/leave/details/$requestId", data: bodyUserId);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = ResponseLeaveRequestDetails.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = ResponseLeaveRequestDetails.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = ResponseLeaveRequestDetails.fromJson(
  //           json.decode(e.response.toString()));
  //       // var obj = responseLeaveTypeFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// Create leave request API -----------------
  // static Future<ApiResponse<ResponseCreateLeaveRequest>> createLeaveRequestApi(
  //     int? userId,
  //     int? leaveTypeId,
  //     int? managerId,
  //     String? applyDate,
  //     String? starDate,
  //     String? endDate,
  //     String? reason,
  //     File? attachmentPath,
  //     ) async {
  //   var fileAttachment = attachmentPath?.path.split('/').last;
  //
  //   var fromData = FormData.fromMap({
  //     "user_id": userId,
  //     "assign_leave_id": leaveTypeId,
  //     "substitute_id": managerId,
  //     "apply_date": applyDate,
  //     "leave_from": starDate,
  //     "leave_to": endDate,
  //     "reason": reason,
  //     "attachment_file": attachmentPath?.path != null
  //         ? await MultipartFile.fromFile(attachmentPath!.path,
  //         filename: fileAttachment)
  //         : null,
  //   });
  //
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/user/leave/request", data: fromData);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseCreateLeaveRequestFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseCreateLeaveRequestFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// Update leave request API -----------------
  // static Future<ApiResponse> updateLeaveRequest(
  //     {final fromData, leaveId}) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/user/leave/request/update/$leaveId", data: fromData);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = response.data['message'];
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: response.data['result'],
  //           message: obj,
  //           data: obj);
  //     } else {
  //       var obj = response.toString();
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: response.data['result'],
  //           message: obj,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = e.response.toString();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// cancel request -----------------
  // static Future<ApiResponse> cancelRequest({final parmas}) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response =
  //     await ApiService.getDio()!.get("/user/leave/request/cancel/$parmas");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = response.data['message'];
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: response.data['result'],
  //           message: obj,
  //           data: obj);
  //     } else {
  //       var obj = response.data['message'];
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = responseCreateLeaveRequestFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// getAllUserData API -----------------
  // static Future<ApiResponse<ResponseAllUser>> getAllUserData(
  //     int? designationId, String? search) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     if (kDebugMode) {
  //       print("/app/get-all-users/$designationId?keywords=$search");
  //     }
  //     var response = await ApiService.getDio()!
  //         .get("/app/get-all-users/${designationId ?? ""}?keywords=$search");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseAllUserFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseAllUserFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = responseAllUserFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// Phonebook Details API -----------------
  // static Future<ApiResponse<PhonebookDetailsModel>> getPhonebookDetails(
  //     id) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     if (kDebugMode) {
  //       print("/app/get-all-users/$id");
  //     }
  //     var response = await ApiService.getDio()!.get("/user/details/$id");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = phonebookDetailsModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = phonebookDetailsModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = phonebookDetailsModelFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// /////////////////////////////////////// LEAVE API END ////////////////////////////////////////////////////////

  /// /////////////////////////////////////// Attendance API START ////////////////////////////////////////////////////////

  /// Attendance CheckIN API -----------------
  // static Future<ApiResponse<ResponseCheckIn>> checkInApi(
  //     BodyCheckIn? bodyCheckIn) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/user/attendance/check-in", data: bodyCheckIn);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = ResponseCheckIn.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = ResponseCheckIn.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = ResponseCheckIn.fromJson(json.decode(e.response.toString()));
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// Attendance CheckOut API -----------------
  // static Future<ApiResponse<ResponseCheckOut>> checkOutApi(
  //     BodyCheckOut bodyCheckOut, int? checkInID) async {
  //   if (kDebugMode) {
  //     print(bodyCheckOut.toJson());
  //   }
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/user/attendance/check-out/$checkInID", data: bodyCheckOut);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = ResponseCheckOut.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = ResponseCheckOut.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = ResponseCheckOut.fromJson(json.decode(e.response.toString()));
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// Attendance LateReason API -----------------
  // static Future<ApiResponse> lateReasonApi(
  //     BodyLateReason bodyLateReason, int? lateReasonId) async {
  //   if (kDebugMode) {
  //     print(bodyLateReason.toJson());
  //   }
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.post(
  //         "/user/attendance/late-in-reason/$lateReasonId",
  //         data: bodyLateReason);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: response.data["result"],
  //           message: response.data["message"],
  //           data: response.data["data"]);
  //     } else {
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: response.data["result"],
  //           message: response.data["message"],
  //           data: response.data["data"]);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: e.response!.data["error"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// Attendance Status API -----------------
  static Future<ApiResponse<ResponseAttendanceStatus>> attendanceStatus(
      BodyUserId bodyUserId) async {
    if (kDebugMode) {
      print(bodyUserId.toJson());
    }
    try {
      // EasyLoading.show(status: 'loading...');
      var response = await ApiService.getDio()!.post(
          "/user/attendance/get-checkin-checkout-status",
          data: bodyUserId);
      // EasyLoading.dismiss();
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.data);
        }
        var obj = ResponseAttendanceStatus.fromJson(response.data);
        return ApiResponse(
            httpCode: response.statusCode,
            result: obj.result,
            message: obj.message,
            data: obj);
      } else {
        var obj = ResponseAttendanceStatus.fromJson(response.data);
        return ApiResponse(
            httpCode: response.statusCode,
            result: obj.result,
            message: obj.message,
            data: obj);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        // EasyLoading.dismiss();
        return ApiResponse(
            httpCode: e.response!.statusCode,
            result: e.response!.data["result"],
            message: e.response!.data["message"],
            error: e.response!.data["error"]);
      } else {
        // EasyLoading.dismiss();
        if (kDebugMode) {
          print(e.message);
        }
        return ApiResponse(
            httpCode: -1, message: "Connection error ${e.message}");
      }
    }
  }

  /// Attendance daily Report API -----------------
  // static Future<ApiResponse<AttendanceDailyReport>> attendanceReportDaily(
  //     String? date, int? userId) async {
  //   var bodyDailyReport = FormData.fromMap({
  //     "user_id": userId,
  //     "date": date,
  //   });
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.post(
  //         "/report/attendance/particular-date",
  //         data: bodyDailyReport);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = AttendanceDailyReport.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = AttendanceDailyReport.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: e.response!.data["error"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// Attendance Report API -----------------
  // static Future<ApiResponse<AttendanceReport>> attendanceReport(
  //     BodyAttendanceReport bodyAttendanceReport, int? userId) async {
  //   if (kDebugMode) {
  //     print(bodyAttendanceReport.toJson());
  //   }
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.post(
  //         "/report/attendance/particular-month/$userId",
  //         data: bodyAttendanceReport);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = AttendanceReport.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = AttendanceReport.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: e.response!.data["error"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// Attendance base-settings API -----------------
  static Future<ApiResponse<ResponseBaseSetting>> baseSettingApi() async {
    try {
      var response = await ApiService.getDio()!.get("/api/user/get-current-user");
      
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.data);
        }
        var obj = ResponseBaseSetting.fromJson(response.data);
        return ApiResponse(
            httpCode: response.statusCode,
            message: obj.message,
            result: true,
            data: obj);
      }
      
      // Handle non-200 status codes
      var obj = ResponseBaseSetting.fromJson(response.data);
      return ApiResponse(
          httpCode: response.statusCode,
          message: obj.message,
          result: false,
          data: obj
      );
      
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return ApiResponse(
            httpCode: e.response?.statusCode,
            message: e.response?.data["message"],
            result: false,
            error: e.response?.data["error"]);
      }
      
      if (kDebugMode) {
        print(e.message);
      }
      return ApiResponse(
          httpCode: -1,
          result: false, 
          message: "Connection error ${e.message}"
      );
    }
  }

  /// /////////////////////////////////////// Attendance API END ////////////////////////////////////////////////////////

  /// /////////////////////////////////////// Visit API START ////////////////////////////////////////////////////////

  /// Create Visit API -----------------
  // static Future<ApiResponse<ResponseCreateVisit>> createVisitApi(
  //     BodyCreateVisit bodyCreateVisit) async {
  //   if (kDebugMode) {
  //     print(bodyCreateVisit.toJson());
  //   }
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/visit/create", data: bodyCreateVisit);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = ResponseCreateVisit.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = ResponseCreateVisit.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = ResponseCreateVisit.fromJson(e.response!.data);
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// Update Visit API -----------------
  // static Future<ApiResponse<ResponseCreateVisit>> updateVisitApi(
  //     BodyUpdateVisit bodyUpdateVisit) async {
  //   if (kDebugMode) {
  //     print(bodyUpdateVisit.toJson());
  //   }
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/visit/update", data: bodyUpdateVisit);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = ResponseCreateVisit.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = ResponseCreateVisit.fromJson(response.data);
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: e.response!.data["error"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// update image visit API -----------------
  // static Future<ApiResponse<ResponseImageVisit>> updateImageVisit(
  //     int? userId, File? file) async {
  //   var fileName = file!.path.split('/').last;
  //   var fromData = FormData.fromMap({
  //     "id": userId,
  //     "visit_image": await MultipartFile.fromFile(file.path, filename: fileName)
  //   });
  //   if (kDebugMode) {
  //     print(fromData);
  //   }
  //   try {
  //     EasyLoading.show(status: 'Uploading...');
  //     var response = await ApiService.getDio()!
  //         .post("/visit/image-upload", data: fromData);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseImageVisitFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseImageVisitFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //         httpCode: e.response!.statusCode,
  //         result: e.response!.data["result"],
  //         message: e.response!.data["message"],
  //       );
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// visit List API -----------------
  // static Future<ApiResponse<ResponseVisitList>> getVisitListApi() async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.get("/visit/list");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseVisitListFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseVisitListFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// History visit List API -----------------
  // static Future<ApiResponse<ResponseVisitHistory>> historyVisitApi(
  //     BodyAttendanceReport bodyHistory) async {
  //   if (kDebugMode) {
  //     print(bodyHistory.toJson());
  //   }
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response =
  //     await ApiService.getDio()!.post("/visit/history", data: bodyHistory);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseVisitHistoryFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseVisitHistoryFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// create Note API -----------------
  // static Future<ApiResponse<ResponseProfileImage>> createNoteAPi(
  //     int? userId, File? file) async {
  //   var fileName = file!.path.split('/').last;
  //   var fromData = FormData.fromMap({
  //     "id": userId,
  //     "visit_image": await MultipartFile.fromFile(file.path, filename: fileName)
  //   });
  //   if (kDebugMode) {
  //     print(fromData);
  //   }
  //   try {
  //     EasyLoading.show(status: 'Uploading...');
  //     var response = await ApiService.getDio()!
  //         .post("/visit/image-upload", data: fromData);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseProfileImageFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseProfileImageFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = responseProfileImageFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// Change status visit API -----------------
  // static Future<ApiResponse<ResponseChangeStatus>> changeStatusVisit(
  //     BodyChangeStatus bodyChangeStatus) async {
  //   if (kDebugMode) {
  //     print(bodyChangeStatus.toJson());
  //   }
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/visit/change-status", data: bodyChangeStatus);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseChangeStatusFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseChangeStatusFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //         httpCode: e.response!.statusCode,
  //         result: e.response!.data["result"],
  //         message: e.response!.data["message"],
  //       );
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// CreateNoteVisit API -----------------
  // static Future<ApiResponse<ResponseCreateVisitNote>> createNoteVisit(
  //     BodyCreateNote bodyCreateNote) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/visit/create-note", data: bodyCreateNote);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseCreateVisitNoteFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseCreateVisitNoteFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //         httpCode: e.response!.statusCode,
  //         result: e.response!.data["result"],
  //         message: e.response!.data["message"],
  //       );
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// Reschedule visit API -----------------
  // static Future<ApiResponse<ResponseVerificationCode>> createRescheduleVisitApi(
  //     BodyRescheduleVisit bodyRescheduleVisit) async {
  //   if (kDebugMode) {
  //     print(bodyRescheduleVisit.toJson());
  //   }
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/visit/create-schedule", data: bodyRescheduleVisit);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseVerificationCodeFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseVerificationCodeFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = responseVerificationCodeFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// cancel visit API -----------------
  // static Future<ApiResponse<ResponseVerificationCode>> cancelVisitApi(
  //     BodyCancelVisit bodyCancelVisit) async {
  //   if (kDebugMode) {
  //     print(bodyCancelVisit.toJson());
  //   }
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/visit/change-status", data: bodyCancelVisit);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseVerificationCodeFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseVerificationCodeFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = responseVerificationCodeFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// Visit details API -----------------
  // static Future<ApiResponse<ResponseVisitDetails>> visitDetails(
  //     int? visitID) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.get("/visit/show/$visitID");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseVisitDetailsFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseVisitDetailsFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// /////////////////////////////////////// Visit API End ////////////////////////////////////////////////////////

  /// /////////////////////////////////////// Notice API Start ////////////////////////////////////////////////////////

  ///  Notice List  API -----------------
  // static Future<ApiResponse<ResponseNoticeList>> noticeListApi(
  //     BodyAttendanceReport bodyNoticeList) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response =
  //     await ApiService.getDio()!.post("/notice/list", data: bodyNoticeList);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseNoticeListFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseNoticeListFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // ///  Notice Details API -----------------
  // static Future<ApiResponse<ResponseNoticeDetails>> noticeDetailsApi(
  //     int? noticeId) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.get("/notice/show/$noticeId");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseNoticeDetailsFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseNoticeDetailsFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // ///  Clear notice API -----------------
  // static Future<ApiResponse<ResponseClearNotification>> clearNoticeApi() async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.get("/notice/clear");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseClearNotificationFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseClearNotificationFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // ///  Clear Notification API -----------------
  // static Future<ApiResponse<ResponseClearNotification>>
  // clearNotificationApi() async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.get("/user/notification/clear");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseClearNotificationFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseClearNotificationFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// /////////////////////////////////////// Notice API End ////////////////////////////////////////////////////////

  /// /////////////////////////////////////// support API Start ////////////////////////////////////////////////////////

  ///  support create API -----------------
  // static Future<ApiResponse<ResponseSupportCreate>> supportCreateApi(
  //     String? subject,
  //     String? description,
  //     File? attachmentPath,
  //     int? priorityId) async {
  //   var fileAttachment = attachmentPath?.path.split('/').last;
  //   var fromData = FormData.fromMap({
  //     "subject": subject,
  //     "description": description,
  //     "priority_id": priorityId,
  //     "attachment_file": attachmentPath?.path != null
  //         ? await MultipartFile.fromFile(attachmentPath!.path,
  //         filename: fileAttachment)
  //         : null,
  //   });
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/support-ticket/add", data: fromData);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseSupportCreateFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseSupportCreateFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = responseSupportCreateFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  ///  Support ticket List API -----------------
  // static Future<ApiResponse<ResponseSupportTicketList>> supportTicketListApi(
  //     BodySupportTicket bodySupportTicket) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/support-ticket/list", data: bodySupportTicket);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseSupportTicketListFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseSupportTicketListFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // ///  Support Details API -----------------
  // static Future<ApiResponse<ResponseSupportDetails>> supportDetailsApi(
  //     int? supportId) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response =
  //     await ApiService.getDio()!.get("/support-ticket/show/$supportId");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseSupportDetailsFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseSupportDetailsFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// /////////////////////////////////////// Support API End ////////////////////////////////////////////////////////
  //
  // /// /////////////////////////////////////// Break API Start ////////////////////////////////////////////////////////
  //
  // /// BreakTime API -----------------
  // static Future<ApiResponse<ResponseBreak>> breakTimeApi(
  //     BodyBreakTime bodyBreakTime, String? statusSlug) async {
  //   if (kDebugMode) {
  //     print(bodyBreakTime.toJson());
  //   }
  //   try {
  //     var response = await ApiService.getDio()!
  //         .post("/user/attendance/break-back/$statusSlug", data: bodyBreakTime);
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseBreakFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseBreakFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  ///  Break History API -----------------
  // static Future<ApiResponse<ResponseBreakHistory>> breakHistoryApi(
  //     BodyUserId bodyUserId) async {
  //   try {
  //     var response = await ApiService.getDio()!
  //         .post("/user/attendance/break-status", data: bodyUserId);
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseBreakHistoryFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseBreakHistoryFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // ///  Break report History API -----------------
  // static Future<ApiResponse<ResponseBreakReport>> breakReportHistory(
  //     BodyBreakReport breakReport) async {
  //   if (kDebugMode) {
  //     print(breakReport.toJson());
  //   }
  //   try {
  //     var response = await ApiService.getDio()!
  //         .post("/user/attendance/break-history", data: breakReport);
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseBreakReportFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseBreakReportFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // ///  Notification List API -----------------
  // static Future<ApiResponse<NotificationModel>> notificationList() async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.get("/user/notification");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = notificationModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = notificationModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = notificationModelFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // ///  Notification List API -----------------
  // static Future<ApiResponse<ReadNotification>> readNotification(
  //     String? userId) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .get("/user/read-notification?notification_id=$userId");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = readNotificationFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = readNotificationFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       // var obj = notificationModelFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// Approval List API -----------------
  // static Future<ApiResponse<ResponseApprovalList>> getApprovalListApi() async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response =
  //     await ApiService.getDio()!.post("/user/leave/approval/list/view");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseApprovalListFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseApprovalListFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// Approval Details API -----------------
  // static Future<ApiResponse<ResponseApprovalDetails>> getApprovalDetails(
  //     int? id, BodyUserId bodyUserId) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/user/leave/details/$id", data: bodyUserId);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseApprovalDetailsFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseApprovalDetailsFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// approvalOrReject API -----------------
  // static Future<ApiResponse<ResponseApprovalOrReject>> approvalOrReject(
  //     int? approvedId, int? type) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .get("/user/leave/approval/status-change/$approvedId/$type");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseApprovalOrRejectFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseApprovalOrRejectFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// ///////////////////////////////////////////// Appreciate list Start .......................
  //
  // /// getOfficialInfo API -----------------
  // static Future<ApiResponse<ResponseAppreciateList>> gerAppreciateList(
  //     BodyUserId bodyUserId) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/user/profile/appreciates", data: bodyUserId);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseAppreciateListFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseAppreciateListFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// create Appreciate API -----------------
  // static Future<ApiResponse<ResponseCreateAppreciate>> createAppreciateApi(
  //     BodyCreateAppreciate bodyCreateAppreciate) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!
  //         .post("/appreciate/create", data: bodyCreateAppreciate);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseCreateAppreciateFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseCreateAppreciateFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //         httpCode: e.response!.statusCode,
  //         result: e.response!.data["result"],
  //         message: e.response!.data["message"],
  //       );
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// //////////////////////////////////// Token validator........
  //
  // /// create Appreciate API -----------------
  // static Future<ApiResponse<ResponseCreateAppreciate>> validTokenApi(
  //     BodyToken bodyToken) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response =
  //     await ApiService.getDio()!.post("/check-token", data: bodyToken);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseCreateAppreciateFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseCreateAppreciateFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //         httpCode: e.response!.statusCode,
  //         result: e.response!.data["result"],
  //         message: e.response!.data["message"],
  //       );
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// allContentsApi
  // static Future<ApiResponse<ResponseAllContents>> allContentsApi(
  //     String? slag) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.get("/app/all-contents/$slag");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseAllContentsFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseAllContentsFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// Bari koi API -----------------
  // static Future<ApiResponse<ResponseLocation>> getLocation(
  //     double? longitudeResult, double? latitudeResult) async {
  //   try {
  //     // EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDioLocation()!.get(
  //         "geocode?longitude=$longitudeResult&latitude=$latitudeResult&district=true&post_code=true&country=true&sub_district=true&union=true&pauroshova=true&location_type=true&division=true&address=true&area=true");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseLocationFromJson(response.toString());
  //       return ApiResponse(httpCode: response.statusCode, data: obj);
  //     } else {
  //       var obj = responseLocationFromJson(response.toString());
  //       return ApiResponse(httpCode: response.statusCode, data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       // EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode, error: e.response!.data["place"]);
  //     } else {
  //       // EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }

  /// sent token for FCM push notification
  // static Future postSentToken(data) async {
  //   try {
  //     // EasyLoading.show(status: 'loading...');
  //     final response =
  //     await ApiService.getDio()!.post('/user/firebase-token', data: data);
  //     // EasyLoading.dismiss();
  //     if (kDebugMode) {
  //       print(response.data);
  //     }
  //     var obj = response.data;
  //
  //     return obj;
  //   } on DioException {
  //     // EasyLoading.dismiss();
  //     Fluttertoast.showToast(msg: 'Something went wrong');
  //   }
  //   return null;
  // }
  //
  // static Future postCreateMeeting(formData) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     final response =
  //     await ApiService.getDio()!.post("/meeting/create?", data: formData);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       return response.data;
  //     }
  //   } on DioException catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     EasyLoading.dismiss();
  //     Fluttertoast.showToast(msg: "Something went wrong");
  //   }
  // }
  //
  // static Future<ApiResponse<ResponseMeetingList>> postMeetingList(data) async {
  //   try {
  //     // EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.post("/meeting", data: data);
  //     // EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseMeetingListFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseMeetingListFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       // EasyLoading.dismiss();
  //       var obj = responseMeetingListFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       // EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // ///Meeting Details Api
  // static Future<ApiResponse<ResponseMeetingDetails>> getMeetingDetails(
  //     id) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.get("/meeting/show/$id");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseMeetingDetailsFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseMeetingDetailsFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = responseMeetingDetailsFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// Search All Employee API -----------------
  // static Future<ApiResponse<ResponseUserSearch>> getAllEmployee(
  //     String? search) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     if (kDebugMode) {
  //       print("/user/search/$search");
  //     }
  //     var response = await ApiService.getDio()!.get("/user/search/$search");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseUserSearchFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseUserSearchFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = responseUserSearchFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // /// Create Note for HR  -----------------
  // static Future<ApiResponse<ResponseNoticeCreate>> createNoteApi(
  //     fromData) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response =
  //     await ApiService.getDio()!.post("/notice/add", data: fromData);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       var obj = responseNoticeCreateFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = responseNoticeCreateFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"]);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  // //////////////////////////////////////
  //
  // /// Live Location store API -----------------
  // Future<bool> sentStopLocationData(
  //     {List<Map<String, dynamic>>? locations, String? date}) async {
  //   try {
  //     final data = {'date': date, 'locations': locations};
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.post("/user/attendance/live-location-store", data: data);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print("This is response ${response.data}");
  //       }
  //       return true;
  //       // var obj = responseLoginFromJson(response.toString());
  //       // return ApiResponse(
  //       //     httpCode: response.statusCode,
  //       //     result: obj.result,
  //       //     message: obj.message,
  //       //     data: obj);
  //     } else {
  //       // var obj = responseLoginFromJson(response.toString());
  //       // return ApiResponse(
  //       //     httpCode: response.statusCode,
  //       //     result: obj.result,
  //       //     message: obj.message,
  //       //     data: obj);
  //       return false;
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return false;
  //       // var obj = responseLoginFromJson(e.response.toString());
  //       //
  //       // return ApiResponse(
  //       //   httpCode: e.response!.statusCode,
  //       //   result: e.response!.data["result"],
  //       //   message: e.response!.data["message"],
  //       //   error: obj,
  //       // );
  //     } else {
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return false;
  //     }
  //   }
  // }
  //
  // /// Login API -----------------
  // static Future moveDriverLocationData(data) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.post("/login", data: data);
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(response.data);
  //       }
  //       return response.data;
  //       // var obj = responseLoginFromJson(response.toString());
  //       // return ApiResponse(
  //       //     httpCode: response.statusCode,
  //       //     result: obj.result,
  //       //     message: obj.message,
  //       //     data: obj);
  //     } else {
  //       // var obj = responseLoginFromJson(response.toString());
  //       // return ApiResponse(
  //       //     httpCode: response.statusCode,
  //       //     result: obj.result,
  //       //     message: obj.message,
  //       //     data: obj);
  //       return response.data;
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       return e.response?.data;
  //       // var obj = responseLoginFromJson(e.response.toString());
  //       //
  //       // return ApiResponse(
  //       //   httpCode: e.response!.statusCode,
  //       //   result: e.response!.data["result"],
  //       //   message: e.response!.data["message"],
  //       //   error: obj,
  //       // );
  //     } else {
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  //
  // ///task deashboard
  //
  // static Future<ApiResponse<TaskDashboardModel>> getTaskHomeData() async {
  //   try {
  //     var response = await ApiService.getDio()!.get("/tasks");
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print("crm task data......${response.data}");
  //       }
  //       var obj = taskDashboardModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = taskDashboardModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = taskDashboardModelFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  //
  // ///task in progress list
  // static Future<ApiResponse<TaskListModel>> getTaskInProgressListData(
  //     String status, String search,
  //     {String? taskStatusId}) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.get(
  //         "/tasks/list?keyword=$search&status=26&priority=$taskStatusId");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       var obj = taskListModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = taskListModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = taskListModelFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  //
  //
  // ///Complete Task list
  // static Future<ApiResponse<TaskListModel>> getCompleteTaskListData(
  //     String status, String search,
  //     {String? taskStatusId}) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.get(
  //         "/tasks/list?keyword=$search&status=27&priority=$taskStatusId");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       var obj = taskListModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = taskListModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = taskListModelFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  //
  //
  //
  // ///getCrmTaskDetailsData
  // static Future<ApiResponse<TaskDetailsModel>> getTaskDetailsData(
  //     int? id) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.get("/tasks/$id");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(" task details from repo......${response.data}");
  //       }
  //       var obj = taskDetailsModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = taskDetailsModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = taskDetailsModelFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }
  //
  //
  //
  // ///task status change
  // static Future<ApiResponse<TaskDetailsModel>> getTaskStatusCHangeData(
  //     int? id) async {
  //   try {
  //     EasyLoading.show(status: 'loading...');
  //     var response = await ApiService.getDio()!.get("/tasks/change-status?task_id=$id&type=1&change_to=27");
  //     EasyLoading.dismiss();
  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print(" task status change update from repo......${response.data}");
  //       }
  //       var obj = taskDetailsModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     } else {
  //       var obj = taskDetailsModelFromJson(response.toString());
  //       return ApiResponse(
  //           httpCode: response.statusCode,
  //           result: obj.result,
  //           message: obj.message,
  //           data: obj);
  //     }
  //   } on DioException catch (e) {
  //     if (e.type == DioExceptionType.badResponse) {
  //       EasyLoading.dismiss();
  //       var obj = taskDetailsModelFromJson(e.response.toString());
  //       return ApiResponse(
  //           httpCode: e.response!.statusCode,
  //           result: e.response!.data["result"],
  //           message: e.response!.data["message"],
  //           error: obj);
  //     } else {
  //       EasyLoading.dismiss();
  //       if (kDebugMode) {
  //         print(e.message);
  //       }
  //       return ApiResponse(
  //           httpCode: -1, message: "Connection error ${e.message}");
  //     }
  //   }
  // }



}
