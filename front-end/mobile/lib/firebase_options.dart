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
    apiKey: 'AIzaSyARG-bBO4Ua2NCsZG-stM9hUO9ueazhLMI',
    appId: '1:582983299080:web:1cef9030127a28d72ea1bd',
    messagingSenderId: '582983299080',
    projectId: 'vnlaw-bf731',
    authDomain: 'vnlaw-bf731.firebaseapp.com',
    storageBucket: 'vnlaw-bf731.appspot.com',
    measurementId: 'G-MHNNH87998',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAucAXnqMBykGK_lxblqkHPWAMKmZ73WiY',
    appId: '1:582983299080:android:601a8afd93f5fafc2ea1bd',
    messagingSenderId: '582983299080',
    projectId: 'vnlaw-bf731',
    storageBucket: 'vnlaw-bf731.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyANcFdSCxMLHMQ6qZRY0gOAOZm0ktT53HI',
    appId: '1:582983299080:ios:4f6b14f72e45d2862ea1bd',
    messagingSenderId: '582983299080',
    projectId: 'vnlaw-bf731',
    storageBucket: 'vnlaw-bf731.appspot.com',
    iosClientId: '582983299080-ducvvjotac3if6p29vktrlcan7nlu8hc.apps.googleusercontent.com',
    iosBundleId: 'com.example.mobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyANcFdSCxMLHMQ6qZRY0gOAOZm0ktT53HI',
    appId: '1:582983299080:ios:4f6b14f72e45d2862ea1bd',
    messagingSenderId: '582983299080',
    projectId: 'vnlaw-bf731',
    storageBucket: 'vnlaw-bf731.appspot.com',
    iosClientId: '582983299080-ducvvjotac3if6p29vktrlcan7nlu8hc.apps.googleusercontent.com',
    iosBundleId: 'com.example.mobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyARG-bBO4Ua2NCsZG-stM9hUO9ueazhLMI',
    appId: '1:582983299080:web:6cfaf1f1d7277fc22ea1bd',
    messagingSenderId: '582983299080',
    projectId: 'vnlaw-bf731',
    authDomain: 'vnlaw-bf731.firebaseapp.com',
    storageBucket: 'vnlaw-bf731.appspot.com',
    measurementId: 'G-W9Y3CF1MLR',
  );
}
