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
    apiKey: 'AIzaSyDSDFilcHvJPuVyuu7jgFC9lYvjBtHWeCI',
    appId: '1:715569131917:web:70120fc96581a6b9f84dc4',
    messagingSenderId: '715569131917',
    projectId: 'truckiveuser',
    authDomain: 'truckiveuser.firebaseapp.com',
    storageBucket: 'truckiveuser.appspot.com',
    measurementId: 'G-VMW82QMP8Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAo3pBeL4YZHBphW5M6iLB9CgEO-xNhEAQ',
    appId: '1:715569131917:android:a26a2ae5fe4da304f84dc4',
    messagingSenderId: '715569131917',
    projectId: 'truckiveuser',
    storageBucket: 'truckiveuser.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAY1Ewp8QBtli6VD6fQup3dy4PgDc5gbKE',
    appId: '1:715569131917:ios:b4a22889f4706d50f84dc4',
    messagingSenderId: '715569131917',
    projectId: 'truckiveuser',
    storageBucket: 'truckiveuser.appspot.com',
    iosBundleId: 'com.example.truckive',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAY1Ewp8QBtli6VD6fQup3dy4PgDc5gbKE',
    appId: '1:715569131917:ios:14d918e4f752b360f84dc4',
    messagingSenderId: '715569131917',
    projectId: 'truckiveuser',
    storageBucket: 'truckiveuser.appspot.com',
    iosBundleId: 'com.example.truckive.RunnerTests',
  );
}
