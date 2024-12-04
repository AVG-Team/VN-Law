import 'package:flutter/material.dart';
// import 'package:vmoffice/api_service/api_body.dart';
// import 'package:vmoffice/data/model/response_base_settings.dart';
// import 'package:vmoffice/data/server/respository/repository.dart';
// import 'package:vmoffice/utils/shared_preferences.dart';

import '../api_service/api_body.dart';
import '../data/models/response/response_base_settings.dart';
import '../data/repositories/repository.dart';
import '../utils/shared_preferences.dart';

class ApiProvider extends ChangeNotifier {
  String? checkStatus;
  bool? checkIn;
  bool? checkOut;

  int? inHour, inMin, inSec;
  int? outHour, outMin, outSec;
  bool? isUser;
  bool? isAdmin;
  ResponseBaseSetting? baseSetting;

  ApiProvider() {
    setAttendanceStatus();
    getBaseSetting();
  }

  setAttendanceStatus() {
    checkStatus = "Check In";
    notifyListeners();
  }

  /// check In-out status API
  checkInCheckOutStatus() async {
    var userId = await SPUtill.getIntValue(SPUtill.keyUserId);
    var bodyUserId = BodyUserId(userId: userId);
    var apiResponse = await Repository.attendanceStatus(bodyUserId);
    if (apiResponse.result == true) {
      checkIn = apiResponse.data?.data?.checkin;
      checkOut = apiResponse.data?.data?.checkout;
      if (checkIn == false && checkOut == false) {
        checkStatus = "Check In";
        notifyListeners();
      } else if (checkIn == true && checkOut == true) {
        checkStatus = "Check In";
        notifyListeners();
      } else if (checkIn == true && checkOut == false) {
        checkStatus = "Check Out";
        notifyListeners();
      }
    }
  }

  getBaseSetting() async {
    var apiResponse = await Repository.baseSettingApi();
    if (apiResponse.data != null) {
      baseSetting = apiResponse.data;
      isUser = baseSetting?.data?.isUser as bool?;
      isAdmin = baseSetting?.data?.isAdmin as bool?;
      // inHour = baseSetting?.data?.dutySchedule?.startTime?.hour;
      // inMin = baseSetting?.data?.dutySchedule?.startTime?.min;
      // inSec = baseSetting?.data?.dutySchedule?.startTime?.sec;


      // outHour = baseSetting?.data?.dutySchedule?.endTime?.hour;
      // outMin = baseSetting?.data?.dutySchedule?.endTime?.min;
      // outSec = baseSetting?.data?.dutySchedule?.endTime?.sec;
      notifyListeners();
    }
  }
}
