import 'package:flutter/foundation.dart';
import 'package:mobile/screens/auth/login/login_screen.dart';
import 'package:mobile/screens/dashboard_screen.dart';
import '../../data/repositories/repository.dart';
import '../../utils/nav_utail.dart';
import '../../utils/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  String? themeId;

  SplashProvider(context) {
    initFunction(context);
  }

  getThemeID(context) async {
    var apiResponse = await Repository.baseSettingApi();
    if (apiResponse.result == true) {
      NavUtil.replaceScreen(
          context,
          const DashboardScreen()
      );
      notifyListeners();
    }
  }

  initFunction(context) {
    Future.delayed(const Duration(seconds: 2), () async {
      var token = await SPUtill.getValue(SPUtill.keyAuthToken);
      var userId = await SPUtill.getIntValue(SPUtill.keyUserId);
      if (kDebugMode) {
        /// development purpose only
        print("Bearer token: $token");
        print("User Id: $userId");
      }
      if (token != null) {
        getThemeID(context);
      } else {
        NavUtil.replaceScreen(
            context,
            const LoginScreen());
      }
      notifyListeners();
    });
  }

// /// getToken API .............
// void getToken(context) async {
//   var token = await SPUtill.getValue(SPUtill.keyAuthToken);
//   var bodyToken = BodyToken(
//       token: token
//   );
//   var apiResponse = await Repository.validTokenApi(bodyToken);
//   if (apiResponse.result == true) {
//     isValid = true;
//     initFunction(context);
//     notifyListeners();
//   } else {
//     isValid = false;
//     notifyListeners();
//   }
//
// }
}
