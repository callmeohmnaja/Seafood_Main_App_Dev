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
    apiKey: 'AIzaSyCT9XvvAXJEZkxfCHPBUmfV8_gT_FmSHXQ',
    appId: '1:785736376641:web:1a8815553471b24934c1c0',
    messagingSenderId: '785736376641',
    projectId: 'database-seafood-app',
    authDomain: 'database-seafood-app.firebaseapp.com',
    databaseURL:
        'https://database-seafood-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'database-seafood-app.appspot.com',
    measurementId: 'G-07FWN0KE05',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_6BqYTJ_NzPODbKhhDvHuI0-97kyemPw',
    appId: '1:785736376641:android:b1c8f2a8f5dd2dde34c1c0',
    messagingSenderId: '785736376641',
    projectId: 'database-seafood-app',
    databaseURL:
        'https://database-seafood-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'database-seafood-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCMauVu6kr7vpVbrgvt4p3aHsq5ALFS2bc',
    appId: '1:785736376641:ios:5f17fdc6200671b334c1c0',
    messagingSenderId: '785736376641',
    projectId: 'database-seafood-app',
    databaseURL:
        'https://database-seafood-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'database-seafood-app.appspot.com',
    iosBundleId: 'com.example.seafoodApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCMauVu6kr7vpVbrgvt4p3aHsq5ALFS2bc',
    appId: '1:785736376641:ios:5f17fdc6200671b334c1c0',
    messagingSenderId: '785736376641',
    projectId: 'database-seafood-app',
    databaseURL:
        'https://database-seafood-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'database-seafood-app.appspot.com',
    iosBundleId: 'com.example.seafoodApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCT9XvvAXJEZkxfCHPBUmfV8_gT_FmSHXQ',
    appId: '1:785736376641:web:2871c14396828a0c34c1c0',
    messagingSenderId: '785736376641',
    projectId: 'database-seafood-app',
    authDomain: 'database-seafood-app.firebaseapp.com',
    databaseURL:
        'https://database-seafood-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'database-seafood-app.appspot.com',
    measurementId: 'G-1W2V1DBQDB',
  );
}
