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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDOdXBywSOqLxvDoWRIE9lQ2yXwkIdkRj4',
    appId: '1:764349313958:android:dc27e17900f20256825567',
    messagingSenderId: '764349313958',
    projectId: 'trackmyclients-app',
    storageBucket: 'trackmyclients-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCsokBDEudZ3qUGdBPqBIlffDwrz7OJg6s',
    appId: '1:764349313958:ios:9f1c466f9364a998825567',
    messagingSenderId: '764349313958',
    projectId: 'trackmyclients-app',
    storageBucket: 'trackmyclients-app.appspot.com',
    androidClientId: '764349313958-jv7g1jjj9qhhf9h84v4vep7573tg5nhl.apps.googleusercontent.com',
    iosClientId: '764349313958-erh8ifhovhe94un678rhphv4gkuk4hq6.apps.googleusercontent.com',
    iosBundleId: 'com.ghoutani.trackmyclientsApp',
  );

}