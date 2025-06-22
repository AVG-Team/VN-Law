import 'package:VNLAW/screens/auth/login/auth_provider.dart';
import 'package:VNLAW/screens/chat/chatbot_provider.dart';
import 'package:VNLAW/screens/forums/providers/post_details_provider.dart';
import 'package:VNLAW/screens/forums/providers/post_provider.dart';
import 'package:VNLAW/screens/home/home_provider.dart';
import 'package:VNLAW/screens/legal_document/legal_document_provider.dart';
import 'package:VNLAW/screens/splash_screen/splash_screen.dart';
import 'package:VNLAW/utils/app_color.dart';
import 'package:VNLAW/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'api_provider/api_provider.dart';
import 'api_service/connectivity/connectivity_status.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 12.0
    ..progressColor = AppColors.colorPrimary
    ..backgroundColor = Colors.white.withOpacity(0.8)
    ..indicatorColor = AppColors.colorPrimary
    ..textColor = AppColors.colorPrimary
    ..maskColor = Colors.black.withOpacity(0.2)
    ..userInteractions = false
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.custom
    ..loadingStyle = EasyLoadingStyle.custom
    ..textStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    )
    ..boxShadow = [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 8,
        offset: const Offset(0, 2),
      )
    ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print('Build MyApp');
    configLoading();

    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ApiProvider()),
      // ChangeNotifierProvider(create: (_) => LoginProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ChangeNotifierProvider(create: (_) => LegalDocumentProvider()),
      ChangeNotifierProvider(create: (_) => ChatbotProvider()),
      ChangeNotifierProvider(create: (_) => PostProvider()),
      ChangeNotifierProvider(create: (_) => PostDetailsProvider()),
    ], child: MaterialApp(
          navigatorKey: GlobalKey<NavigatorState>(),
          title: 'VNLAW',
          theme: ThemeData.from(colorScheme: const ColorScheme.light())
              .copyWith(
            appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: AppColors.colorPrimary,
                titleTextStyle:
                TextStyle(color: Colors.white, fontSize: 18)),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.colorPrimary,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor:
                  WidgetStateProperty.all(AppColors.colorPrimary),
                )),
          ),
          home: const SplashScreen(),
          builder: EasyLoading.init(),
          onGenerateRoute: AppRoutes.onGenerateRoute,
    ));
  }
}