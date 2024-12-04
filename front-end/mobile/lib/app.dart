import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile/api_service/connectivity/connectivity_status.dart';
import 'package:mobile/screens/auth/login/login_provider.dart';
import 'package:mobile/screens/home/home_provider.dart';
import 'package:mobile/screens/splash_screen/splash_screen.dart';
import 'package:mobile/utils/app_color.dart';
import 'package:provider/provider.dart';

import 'api_provider/api_provider.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.colorPrimary
    ..backgroundColor = Colors.transparent
    ..indicatorColor = AppColors.colorPrimary
    ..textColor = AppColors.colorPrimary
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..boxShadow = <BoxShadow>[];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ApiProvider()),
      ChangeNotifierProvider(create: (_) => LoginProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
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
          home:const SplashScreen(),
          builder: EasyLoading.init(),
    ));
  }
}