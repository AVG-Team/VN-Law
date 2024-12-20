import 'package:flutter/material.dart';
import 'package:mobile/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../custom_widgets/animation/loading/loading_dialog.dart';
import '../../pages/WelcomePage/login_screen.dart';
import '../../pages/WelcomePage/reg_screen.dart';
import '../../services/auth_provider.dart';
import '../../utils/nav_utail.dart';

class WelcomeProvider extends ChangeNotifier {
  final BuildContext context;
  late final AuthProviderCustom authProvider;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  WelcomeProvider(this.context) {
    authProvider = Provider.of<AuthProviderCustom>(context, listen: false);
  }

  void navigateToDashboard() {
    NavUtil.navigateAndClearStack(context, const DashboardScreen());
  }

  void navigateToLogin() {
    NavUtil.navigateScreen(context, const LoginScreen());
  }

  void navigateToRegister() {
    NavUtil.navigateScreen(context, const RegScreen());
  }

  Future<void> handleGoogleSignIn() async {
    try {
      LoadingDialog.show(context);

      final userCredential = await authProvider.signInWithGoogle();

      if (!context.mounted) return;
      LoadingDialog.hide(context);

      if (userCredential != null) {
        Fluttertoast.showToast(
            msg: "Đăng Nhập Thành Công",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 12.0);
        navigateToDashboard();
      }
    } catch (error) {
      if (!context.mounted) return;
      LoadingDialog.hide(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng nhập thất bại: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
