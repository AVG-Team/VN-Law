import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../api_service/api_body.dart';
import '../../../data/models/auth_response/response_login.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/repository.dart';
import '../../../permisson/app_permisson_page.dart';
import '../../../utils/nav_utail.dart';
import '../../../utils/shared_preferences.dart';
import '../../dashboard_screen.dart';

class LoginProvider extends ChangeNotifier {
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();
  String? email;
  String? password;
  String? error;
  bool isError = false;
  bool passwordVisible = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // loc.Location location = loc.Location();
  String? deviceInfoModel;

  LoginProvider() {
    passwordVisible = false;
    getDeviceId();
  }

  bool isValidate() {
    bool isValid = true;
    if (emailTextController.text.isEmpty) {
      email = "Email is required";
      isValid = false;
    } else {
      email = null;
    }

    if (passwordTextController.text.isEmpty) {
      password = "Password is required";
      isValid = false;
    } else {
      password = null;
    }

    notifyListeners();

    return isValid;
  }

  getThemeIDAndNavigation(context) async {
    var apiResponse = await Repository.baseSettingApi();
    if (apiResponse.result == true) {
      // appThemeId = apiResponse.data?.data?.appTheme;
      NavUtil.replaceScreen(
          context,
          const DashboardScreen()
      );
          // const AppPermissionPage(
          //   // appThemeId: appThemeId,
          // ));
      notifyListeners();
    }
  }

  Future<void> neverSatisfied(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location permission'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'You have to grant background location permission.',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  prominentDisclosure,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(
                  height: 36.0,
                ),
                Text(denyMessage),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                locationPermission(context);
              },
              child: const Text('Next'),
            ),
            MaterialButton(
              child: const Text('Continue'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String denyMessage =
      'If the permission is rejected, then you have to manually go to the settings to enable it';
  String prominentDisclosure =
      'Blistavi Dom collects location data to enable user employee attendance and visit feature, also find distance between employee and office position for accurate daily attendance ';

  passwordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void resetTextField() {
    emailTextController.text = "";
    passwordTextController.text = "";
    email = "";
    password = "";
    error = "";
    notifyListeners();
  }

  Future<void> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceInfoModel =
      '${iosDeviceInfo.name}-${iosDeviceInfo.model}-${iosDeviceInfo.systemVersion}';
      final result =
          '${iosDeviceInfo.name}-${iosDeviceInfo.model}-${iosDeviceInfo.identifierForVendor}';
      SPUtill.setValue(SPUtill.keyIosDeviceToken, result);
    } else {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      deviceInfoModel =
      '${androidDeviceInfo.device},${androidDeviceInfo.model},${androidDeviceInfo.brand}';

      final result =
          '${androidDeviceInfo.brand}-${androidDeviceInfo.device}-${androidDeviceInfo.id}';
      SPUtill.setValue(SPUtill.keyAndroidDeviceToken, result);
    }
  }

  void setDataSharePreferences(ResponseLogin? responseLogin) {
    SPUtill.setValue(SPUtill.keyAuthToken, responseLogin?.data?.token);
    SPUtill.setValue(SPUtill.keyUserId, responseLogin?.data?.id);
    SPUtill.setValue(SPUtill.keyName, responseLogin?.data?.name);
    SPUtill.setValue(SPUtill.keyEmail, responseLogin?.data?.email);
    SPUtill.setValue(SPUtill.keyProfileImage, responseLogin?.data?.profileImage());
    SPUtill.setBoolValue(SPUtill.keyIsAdmin, responseLogin?.data?.isAdmin());
    SPUtill.setBoolValue(SPUtill.keyIsUser, responseLogin?.data?.isUser());
  }

  void getUserInfo(context) async {
    var bodyLogin = BodyLogin(
        email: emailTextController.text,
        password: passwordTextController.text
    );

    var apiResponse = await AuthRepository.getLogin(bodyLogin);
    if (apiResponse.result == true) {
      setDataSharePreferences(apiResponse.data);

      Fluttertoast.showToast(
          msg: apiResponse.message ?? "",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);

      resetTextField();
      getThemeIDAndNavigation(context);
    } else {
      // Thống nhất xử lý lỗi chung
      String errorMessage = apiResponse.message ?? "Đăng nhập thất bại";
      Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
    }
  }

  locationPermission(context) async {
    Navigator.pop(context);
  }


}
