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
    apiKey: 'AIzaSyCDTwIHaTWgoZxuN04NOIcNldUK1ORWYgw',
    appId: '1:1024929076207:web:0b926ac2a87f4ee8efdc1a',
    messagingSenderId: '1024929076207',
    projectId: 'calendar-phone-auth',
    authDomain: 'calendar-phone-auth.firebaseapp.com',
    databaseURL: 'https://calendar-phone-auth.firebaseio.com',
    storageBucket: 'calendar-phone-auth.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5FEP6mkIghDxQ3JoQBjYt-BjEL83Alu8',
    appId: '1:1024929076207:android:dbc1bcae5873cba9efdc1a',
    messagingSenderId: '1024929076207',
    projectId: 'calendar-phone-auth',
    databaseURL: 'https://calendar-phone-auth.firebaseio.com',
    storageBucket: 'calendar-phone-auth.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDoaurWjk_YFKEgQL0Wuahpqd-2VBHQexo',
    appId: '1:1024929076207:ios:9abecf636b78624eefdc1a',
    messagingSenderId: '1024929076207',
    projectId: 'calendar-phone-auth',
    databaseURL: 'https://calendar-phone-auth.firebaseio.com',
    storageBucket: 'calendar-phone-auth.appspot.com',
    iosClientId: '1024929076207-sq1q1rmas9enfrgbi5ghgrpj8imu5p93.apps.googleusercontent.com',
    iosBundleId: 'com.example.scoreflash',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDoaurWjk_YFKEgQL0Wuahpqd-2VBHQexo',
    appId: '1:1024929076207:ios:6a2bdabc59f37239efdc1a',
    messagingSenderId: '1024929076207',
    projectId: 'calendar-phone-auth',
    databaseURL: 'https://calendar-phone-auth.firebaseio.com',
    storageBucket: 'calendar-phone-auth.appspot.com',
    iosClientId: '1024929076207-ekf5tt0t2shk12d12ru52n4tdhrtupeg.apps.googleusercontent.com',
    iosBundleId: 'com.example.scoreflash.RunnerTests',
  );
}
