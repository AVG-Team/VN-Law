import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile/screens/splash/splash_screen.dart';
import 'package:mobile/services/auth_provider.dart';
import 'package:mobile/utils/app_color.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthProviderCustom()),
    ], child: MaterialApp(
      navigatorKey: GlobalKey<NavigatorState>(),
      title: 'AI Legal Chatbot VNLAW',
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
            )
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    ));
  }
}