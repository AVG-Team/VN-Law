import 'package:VNLAW/utils/routes.dart';
import 'package:flutter/material.dart';

class NavUtilAnimation {
  static void navigateScreen(BuildContext context, String name) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        settings: RouteSettings(name: name),
        pageBuilder: (context, animation, secondaryAnimation) => AppRoutes.getRoute(name),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.decelerate;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  static void navigateScreenRevert(BuildContext context, String name) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        settings: RouteSettings(name: name),
        pageBuilder: (context, animation, secondaryAnimation) => AppRoutes.getRoute(name),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0); // từ trái sang phải
          const end = Offset.zero;
          const curve = Curves.decelerate;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }
}