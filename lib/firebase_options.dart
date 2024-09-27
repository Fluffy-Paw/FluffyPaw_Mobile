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
    apiKey: 'AIzaSyAz9M7VhqsSaWsWtDWzylkAuGQ9P-vIM0g',
    appId: '1:126308072976:web:d37fc07abe94a3932a5495',
    messagingSenderId: '126308072976',
    projectId: 'capstone-c6fef',
    authDomain: 'capstone-c6fef.firebaseapp.com',
    storageBucket: 'capstone-c6fef.appspot.com',
    measurementId: 'G-T1911TVJ9B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcP-WmfiOidvW8LXGd1Oll832Dt18OFbg',
    appId: '1:126308072976:android:01c763c8fe82bb0e2a5495',
    messagingSenderId: '126308072976',
    projectId: 'capstone-c6fef',
    storageBucket: 'capstone-c6fef.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFCpeaxz4MrCI6rD0N33glIV1jse__v2g',
    appId: '1:126308072976:ios:7bbdbfa5f4ac16552a5495',
    messagingSenderId: '126308072976',
    projectId: 'capstone-c6fef',
    storageBucket: 'capstone-c6fef.appspot.com',
    iosBundleId: 'com.example.fluffypawmobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCFCpeaxz4MrCI6rD0N33glIV1jse__v2g',
    appId: '1:126308072976:ios:7bbdbfa5f4ac16552a5495',
    messagingSenderId: '126308072976',
    projectId: 'capstone-c6fef',
    storageBucket: 'capstone-c6fef.appspot.com',
    iosBundleId: 'com.example.fluffypawmobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAz9M7VhqsSaWsWtDWzylkAuGQ9P-vIM0g',
    appId: '1:126308072976:web:30053d1ff79558bc2a5495',
    messagingSenderId: '126308072976',
    projectId: 'capstone-c6fef',
    authDomain: 'capstone-c6fef.firebaseapp.com',
    storageBucket: 'capstone-c6fef.appspot.com',
    measurementId: 'G-J8ZQZMVY22',
  );
}
