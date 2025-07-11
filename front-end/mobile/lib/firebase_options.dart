// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB899dV_5GkoZ_6OARTuyiZ7ErruiynH-s',
    appId: '1:739767436237:web:7b837083db1ac056923a84',
    messagingSenderId: '739767436237',
    projectId: 'vnlaw-d68a3',
    authDomain: 'vnlaw-d68a3.firebaseapp.com',
    storageBucket: 'vnlaw-d68a3.firebasestorage.app',
    measurementId: 'G-CVVM6W40DJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHY35HGfDhoNh8FfSm_Ac6W_epBdKHaXg',
    appId: '1:739767436237:android:30c721f36349273e923a84',
    messagingSenderId: '739767436237',
    projectId: 'vnlaw-d68a3',
    storageBucket: 'vnlaw-d68a3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsvoU57_ANdwLUlHLidjCk91RvMl5gRqI',
    appId: '1:739767436237:ios:fbf5c33b699a33fa923a84',
    messagingSenderId: '739767436237',
    projectId: 'vnlaw-d68a3',
    storageBucket: 'vnlaw-d68a3.firebasestorage.app',
    androidClientId: '739767436237-v04p9kjc8fulonv895cjvkqjfn59qflu.apps.googleusercontent.com',
    iosClientId: '739767436237-umdgal4u4bv03pu9vi6ji5jm45jvhlej.apps.googleusercontent.com',
    iosBundleId: 'com.example.mobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAsvoU57_ANdwLUlHLidjCk91RvMl5gRqI',
    appId: '1:739767436237:ios:fbf5c33b699a33fa923a84',
    messagingSenderId: '739767436237',
    projectId: 'vnlaw-d68a3',
    storageBucket: 'vnlaw-d68a3.firebasestorage.app',
    androidClientId: '739767436237-v04p9kjc8fulonv895cjvkqjfn59qflu.apps.googleusercontent.com',
    iosClientId: '739767436237-umdgal4u4bv03pu9vi6ji5jm45jvhlej.apps.googleusercontent.com',
    iosBundleId: 'com.example.mobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB899dV_5GkoZ_6OARTuyiZ7ErruiynH-s',
    appId: '1:739767436237:web:54744e98eb654ddb923a84',
    messagingSenderId: '739767436237',
    projectId: 'vnlaw-d68a3',
    authDomain: 'vnlaw-d68a3.firebaseapp.com',
    storageBucket: 'vnlaw-d68a3.firebasestorage.app',
    measurementId: 'G-E42469REZW',
  );
}
