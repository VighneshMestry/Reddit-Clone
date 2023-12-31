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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAiORL4MSaMO41uXutmcJAz5KV-81LlMb8',
    appId: '1:282258641876:web:d0ce9ab35aa1a7f443bc41',
    messagingSenderId: '282258641876',
    projectId: 'reddit-clone-f1ce4',
    authDomain: 'reddit-clone-f1ce4.firebaseapp.com',
    storageBucket: 'reddit-clone-f1ce4.appspot.com',
    measurementId: 'G-C5C7PBX6L4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzX3xcoWBDGFH43aqyHPnVEIX_CfyvoUY',
    appId: '1:282258641876:android:16f4778c2b7598a443bc41',
    messagingSenderId: '282258641876',
    projectId: 'reddit-clone-f1ce4',
    storageBucket: 'reddit-clone-f1ce4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgCgStezZS1zsYFbIpwSwMhExiIltMbPE',
    appId: '1:282258641876:ios:a13e5976a7b825e643bc41',
    messagingSenderId: '282258641876',
    projectId: 'reddit-clone-f1ce4',
    storageBucket: 'reddit-clone-f1ce4.appspot.com',
    iosBundleId: 'com.example.redditClone',
  );
}
