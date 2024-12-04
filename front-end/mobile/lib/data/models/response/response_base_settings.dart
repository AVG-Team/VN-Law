// To parse this JSON data, do
//
//     final responseAttendanceStatus = responseAttendanceStatusFromJson(jsonString);

import 'dart:convert';

import '../auth_response/response_login.dart';

ResponseBaseSetting responseAttendanceStatusFromJson(String str) =>
    ResponseBaseSetting.fromJson(json.decode(str));

String responseAttendanceStatusToJson(ResponseBaseSetting data) =>
    json.encode(data.toJson());

class ResponseBaseSetting {
  ResponseBaseSetting({
    this.result,
    this.message,
    this.data,
  });

  bool? result;
  String? message;
  UserModel? data;

  factory ResponseBaseSetting.fromJson(Map<String, dynamic> json) =>
      ResponseBaseSetting(
          result: json["result"],
          message: json["message"],
          data: json["data"] != null ? UserModel.fromJson(json["data"]) : null);

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "data": data!.toJson(),
      };
}

// class DutySchedule {
//   DutySchedule({
//     this.startTime,
//     this.endTime,
//   });
//
//   Time? startTime;
//   Time? endTime;
//
//   factory DutySchedule.fromJson(Map<String, dynamic> json) => DutySchedule(
//         startTime: Time.fromJson(json["start_time"]),
//         endTime: Time.fromJson(json["end_time"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "start_time": startTime!.toJson(),
//         "end_time": endTime!.toJson(),
//       };
// }
//
// class Time {
//   Time({
//     this.hour,
//     this.min,
//     this.sec,
//   });
//
//   int? hour;
//   int? min;
//   int? sec;
//
//   factory Time.fromJson(Map<String, dynamic> json) => Time(
//         hour: json["hour"],
//         min: json["min"],
//         sec: json["sec"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "hour": hour,
//         "min": min,
//         "sec": sec,
//       };
// }
//
// class LiveTracking {
//   LiveTracking({
//     this.appSyncTime,
//     this.liveDataStoreTime,
//   });
//
//   String? appSyncTime;
//   String? liveDataStoreTime;
//
//   factory LiveTracking.fromJson(Map<String, dynamic> json) => LiveTracking(
//       appSyncTime: json["app_sync_time"],
//       liveDataStoreTime: json["live_data_store_time"]);
//
//   Map<String, dynamic> toJson() =>
//       {"app_sync_time": appSyncTime, "live_data_store_time": liveDataStoreTime};
// }
//
// class BreakStatus {
//   BreakStatus(
//       {this.date, this.breakTime, this.backTime, this.status, this.diffTime});
//
//   DateTime? date;
//   String? breakTime;
//   String? backTime;
//   String? status;
//   String? diffTime;
//
//   factory BreakStatus.fromJson(Map<String, dynamic> json) => BreakStatus(
//       date: json["date"] != null ? DateTime.parse(json["date"]) : null,
//       breakTime: json["break_time"],
//       backTime: json["back_time"],
//       status: json["status"],
//       diffTime: json["diff_time"]);
//
//   Map<String, dynamic> toJson() => {
//         "date":
//             "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
//         "break_time": breakTime,
//         "back_time": backTime,
//         "status": status,
//         "diff_time": diffTime
//       };
// }
//
// class TimeWish {
//   TimeWish({
//     this.wish,
//     this.subTitle,
//     this.image,
//   });
//
//   String? wish;
//   String? subTitle;
//   String? image;
//
//   factory TimeWish.fromJson(Map<String, dynamic> json) => TimeWish(
//         wish: json["wish"],
//         subTitle: json["sub_title"],
//         image: json["image"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "wish": wish,
//         "sub_title": subTitle,
//         "image": image,
//       };
// }
