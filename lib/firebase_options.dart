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
    apiKey: 'AIzaSyDm1y9uJkgo_W9ffZSCjKRDJeTkr7FvxJU',
    appId: '1:689664259695:web:7d0c814487ab33d8013f9a',
    messagingSenderId: '689664259695',
    projectId: 'gempedia-c5134',
    authDomain: 'gempedia-c5134.firebaseapp.com',
    storageBucket: 'gempedia-c5134.firebasestorage.app',
    measurementId: 'G-BHX33QKYM2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANGmLS8yVOjkLOE0ZrBGCnLRnZH1rb5ZA',
    appId: '1:689664259695:android:63f246a814177abb013f9a',
    messagingSenderId: '689664259695',
    projectId: 'gempedia-c5134',
    storageBucket: 'gempedia-c5134.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKI06mc5NiJfT_PGgyITlv5KwRJrRs2PQ',
    appId: '1:689664259695:ios:fbe86aede9945f74013f9a',
    messagingSenderId: '689664259695',
    projectId: 'gempedia-c5134',
    storageBucket: 'gempedia-c5134.firebasestorage.app',
    iosClientId: '689664259695-knkj277p8298hthnsorvnu50q89cpe3l.apps.googleusercontent.com',
    iosBundleId: 'com.aigs.gempedia',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCKI06mc5NiJfT_PGgyITlv5KwRJrRs2PQ',
    appId: '1:689664259695:ios:53b0d66f89284787013f9a',
    messagingSenderId: '689664259695',
    projectId: 'gempedia-c5134',
    storageBucket: 'gempedia-c5134.firebasestorage.app',
    iosClientId: '689664259695-hu21lkklnqg0i8hkmplgnmsuptlbcqns.apps.googleusercontent.com',
    iosBundleId: 'com.example.dicAppFlutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDm1y9uJkgo_W9ffZSCjKRDJeTkr7FvxJU',
    appId: '1:689664259695:web:36cf5b47668e3760013f9a',
    messagingSenderId: '689664259695',
    projectId: 'gempedia-c5134',
    authDomain: 'gempedia-c5134.firebaseapp.com',
    storageBucket: 'gempedia-c5134.firebasestorage.app',
    measurementId: 'G-S76SWYGLY1',
  );
}
