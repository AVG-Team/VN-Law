// To parse this JSON data, do
//
//     final responseAttendanceStatus = responseAttendanceStatusFromJson(jsonString);

import 'dart:convert';

ResponseAttendanceStatus responseAttendanceStatusFromJson(String str) => ResponseAttendanceStatus.fromJson(json.decode(str));

String responseAttendanceStatusToJson(ResponseAttendanceStatus data) => json.encode(data.toJson());

class ResponseAttendanceStatus {
  ResponseAttendanceStatus({
    this.result,
    this.message,
    this.data,
  });

  bool? result;
  String? message;
  Data? data;

  factory ResponseAttendanceStatus.fromJson(Map<String, dynamic> json) => ResponseAttendanceStatus(
    result: json["result"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.checkin,
    this.checkout,
    this.inTime,
    this.outTime,
    this.stayTime
  });

  int? id;
  bool? checkin;
  bool? checkout;
  String? inTime;
  String? outTime;
  String? stayTime;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      id: json["id"],
      checkin: json["checkin"],
      checkout: json["checkout"],
      inTime: json["in_time"],
      outTime: json["out_time"],
      stayTime: json["stay_time"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "checkin": checkin,
    "checkout": checkout,
    "in_time": inTime,
    "out_time": outTime,
    "stay_time": stayTime
  };
}
