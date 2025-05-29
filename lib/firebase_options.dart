// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCSYggpoKQFlbD2hnVvaxDd1Pi6exIaS8o',
    appId: '1:140280106213:web:bc42765751c8cb9d2f980c',
    messagingSenderId: '140280106213',
    projectId: 'smartstudyapp-54d78',
    authDomain: 'smartstudyapp-54d78.firebaseapp.com',
    storageBucket: 'smartstudyapp-54d78.firebasestorage.app',
    measurementId: 'G-8RJ1R4H33G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSYggpoKQFlbD2hnVvaxDd1Pi6exIaS8o',
    appId: '1:140280106213:android:9642d9e9a98fc2f12f980c',
    messagingSenderId: '140280106213',
    projectId: 'smartstudyapp-54d78',
    storageBucket: 'smartstudyapp-54d78.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCSYggpoKQFlbD2hnVvaxDd1Pi6exIaS8o',
    appId: '1:140280106213:ios:cfb253b5679fbff32f980c',
    messagingSenderId: '140280106213',
    projectId: 'smartstudyapp-54d78',
    storageBucket: 'smartstudyapp-54d78.firebasestorage.app',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.example.smartStudyScheduler',
  );




}
