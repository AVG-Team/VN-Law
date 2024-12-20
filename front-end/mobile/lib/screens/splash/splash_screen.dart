import 'package:flutter/material.dart';
import 'package:mobile/screens/splash/splash_provider.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/animation/bounce_animation/bounce_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashProvider(context),
      child: Consumer<SplashProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    BounceAnimationBuilder(
                      builder: (_, __) {
                        return Center(
                          child: InteractiveViewer(
                            scaleEnabled: false,
                            boundaryMargin:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Image.asset(
                              "assets/logo.png",
                              height: 300,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                )),
          );
        },
      ),
    );
  }
}
