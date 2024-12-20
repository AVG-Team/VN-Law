import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/screens/dashboard_screen.dart';

import '../../utils/nav_utail.dart';
import '../auth/welcome_screen.dart';

class SplashProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  SplashProvider(BuildContext context) {
    setContext(context);
    initFunction(context);
  }

  void initFunction(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      if (_context == null) return;

      User? currentUser = _auth.currentUser;

      if (kDebugMode) {
        print("Current user: ${currentUser?.uid}");
      }

      if (!(_context?.mounted ?? false)) return;

      if (currentUser != null) {
        NavUtil.navigateAndClearStack(_context!, const DashboardScreen());
      } else {
        NavUtil.navigateAndClearStack(_context!, const WelcomeScreenWrapper());
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _context = null;
    super.dispose();
  }
}
