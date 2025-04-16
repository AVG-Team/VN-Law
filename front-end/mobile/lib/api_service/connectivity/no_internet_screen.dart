import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../screens/splash_screen/splash_screen.dart';
import '../../utils/nav_utail.dart';
import 'connectivity_status.dart';

class NoInternetScreen extends StatelessWidget {

  final Widget child;

  const NoInternetScreen({super.key,required this.child});

  @override
  Widget build(BuildContext context) {

    context.watch<ConnectivityProvider>().initialise(context);

    final isConnected = context.watch<ConnectivityProvider>().isConnected;

    // print('isConnected $isConnected');

    return Scaffold(
      body: isConnected == true
          ? child : SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Lottie.asset(
                  'assets/no_internet.json',
                  width: double.infinity,
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 55),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children:  <Widget>[
                        const Spacer(),
                        const Text(
                          "Whoops!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            "Slow or no internet connection. Please check your internet settings",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 45,
                          width: 170,
                          child: ElevatedButton(
                            onPressed: () {
                              NavUtil.pushAndRemoveUntil(
                                  context,
                                  const SplashScreen());
                            },
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ),
                            child: const Text("Try again",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                )),
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          )),
    );
  }
}
