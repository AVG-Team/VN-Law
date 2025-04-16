import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/repository.dart';
import '../../utils/routes.dart';
import '../../utils/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  String? themeId;
  bool isLoading = false;
  bool _isDisposed = false;

  SplashProvider(context) {
    initFunction(context);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  getThemeID(context) async {
    try {
      isLoading = true;
      if (!_isDisposed) notifyListeners();
      
      var apiResponse = await Repository.baseSettingApi();
      if (kDebugMode) {
        print("apiResponse: $apiResponse");
      }
      
      if (apiResponse.result == true && apiResponse.data != null) {
        // Process the data if needed
        // themeId = apiResponse.data.themeId; // Uncomment if needed
        // Navigate using named route with arguments
        if (!_isDisposed) {
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.dashboard,
          );
        }
      } else {
        // Handle API failure
        await SPUtill.deleteKey(SPUtill.keyAuthToken);
        if (!_isDisposed) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in getThemeID: $e");
      }
      // Handle any errors
      await SPUtill.deleteKey(SPUtill.keyAuthToken);
      if (!_isDisposed) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    } finally {
      isLoading = false;
      if (!_isDisposed) notifyListeners();
    }
  }

  initFunction(context) {
    Future.delayed(const Duration(seconds: 2), () async {
      var token = await SPUtill.getValue(SPUtill.keyAuthToken);
      if (kDebugMode) {
        /// development purpose only
        print("Bearer token: $token");
      }
      if (token != null) {
        getThemeID(context);
      } else {
        if(!_isDisposed) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      }
      if (!_isDisposed) notifyListeners();
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
