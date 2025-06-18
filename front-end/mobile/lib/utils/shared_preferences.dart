
import 'package:flutter/cupertino.dart';
// import 'package:vmoffice/data/model/menu/menu_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPUtill {
  // static String keyAuthToken = "key_auth_token";
  static String keyIsAdmin = "key_is_admin";
  static String keyIsUser = "key_is_user";
  static String keyUserId = "user_id";
  static String keyProfileImage = "user_profile_image";
  static String keyName = "user_name";
  static String keyEmail = "user_email";
  static String keyRole = "user_role";
  static String keyCheckInID = "check_in_id";
  static String keyAndroidDeviceToken = "android_device_token";
  static String keyIosDeviceToken = "ios_device_token";
  static String keySelectLanguage = "key_select_language";
  static String keyRemoteModeType = "key_remote_mode_type";
  static String keyMenuList = "key_menu_list";
  static String keyRoles= "user_roles";
  static const String keyRefreshToken = 'refresh_token';
  static const String keyAccessToken = 'access_token';

  static setValue(String key, String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value!);
  }

  static setRemoteModeType(String key, int? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value!);
  }

  static Future<int?> getRemoteModeType(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var value = prefs.getInt(key);
      return value;
    } catch (error) {
      return null;
    }
  }

  static setLanguageIntValue(String key, int? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value!);
  }

  static Future<int?> getSelectLanguage(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var value = prefs.getInt(key);
      return value;
    } catch (error) {
      return null;
    }
  }

  static Future<String?> getValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var value = prefs.getString(key);
      return value;
    } catch (error) {
      return null;
    }
  }

  static setIntValue(String key, int? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value!);
  }

  static setBoolValue(String key, bool? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value!);
  }

  static Future<int?> getIntValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var value = prefs.getInt(key);
      return value;
    } catch (error) {
      return null;
    }
  }

  static Future<bool?> getBoolValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var value = prefs.getBool(key);
      return value;
    } catch (error) {
      return null;
    }
  }

  static deleteKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static storeLocalData(
      {@required String? key, @required String? value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key!, value!);
  }

  static Future<String?> getLocalData({@required String? key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key!);
  }

  /// set menu data list
  // static setListValue(String key, List<MenuDatum>? value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(key, jsonEncode(value?.map((e) => e.toJson()).toList()));
  // }

  /// get menu data list
  // static Future<List<MenuDatum>?> getListValue(String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final dataMap = jsonDecode(prefs.getString(key) ?? '[]') as List<dynamic>;
  //
  //   return dataMap.map<MenuDatum>((item) {
  //     return MenuDatum.fromJson(item);
  //   }).toList();
  // }
}
