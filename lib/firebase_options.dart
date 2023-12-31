// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC0JdRh1kmG0EPuxyzcUHYvKxUfLg_gjfI',
    appId: '1:558149320953:web:0dbbfc881a78516ee42228',
    messagingSenderId: '558149320953',
    projectId: 'payment-tracking-app',
    authDomain: 'payment-tracking-app.firebaseapp.com',
    storageBucket: 'payment-tracking-app.appspot.com',
    measurementId: 'G-0ZBQBDXC4L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyhoHhz2gxMf3kd5uRIeW3zD6sOom_JtU',
    appId: '1:558149320953:android:b2cd7ca676fe4254e42228',
    messagingSenderId: '558149320953',
    projectId: 'payment-tracking-app',
    storageBucket: 'payment-tracking-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAbLHQRmMtXjFhVOJHY3p6sppLXtvvX7xI',
    appId: '1:558149320953:ios:d2bf7877fc99a93ae42228',
    messagingSenderId: '558149320953',
    projectId: 'payment-tracking-app',
    storageBucket: 'payment-tracking-app.appspot.com',
    iosBundleId: 'com.example.paymentTracking',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAbLHQRmMtXjFhVOJHY3p6sppLXtvvX7xI',
    appId: '1:558149320953:ios:42535025a8f81d3ee42228',
    messagingSenderId: '558149320953',
    projectId: 'payment-tracking-app',
    storageBucket: 'payment-tracking-app.appspot.com',
    iosBundleId: 'com.example.paymentTracking.RunnerTests',
  );
}
