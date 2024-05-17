import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:trackmyclients_app/firebase_options.dart';

import 'src/config/app_router.dart';
import 'src/utils/styles.dart';

class SecondaryAppProvider extends InheritedWidget {
  final FirebaseApp secondaryApp;

  const SecondaryAppProvider({
    super.key,
    required this.secondaryApp,
    required super.child,
  });

  static FirebaseApp of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<SecondaryAppProvider>()
            as SecondaryAppProvider)
        .secondaryApp;
  }

  @override
  bool updateShouldNotify(SecondaryAppProvider oldWidget) {
    return oldWidget.secondaryApp != secondaryApp;
  }
}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void _sendSMS(String message, List<String> recipents) async {
  // String _result =
  //     await sendSMS(message: message, recipients: recipents, sendDirect: true)
  //         .catchError((onError) {
  //            print(onError);
  //   return onError.toString();
   
  // });
  // print(_result);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final FirebaseApp secondaryApp = await Firebase.initializeApp(
    name: 'Secondary',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  String message = "This is a test message!";
  List<String> recipents = ["+212707347562"];

  _sendSMS(message, recipents);
  runApp(
    SecondaryAppProvider(
      secondaryApp: secondaryApp,
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/',
      routes: Routes.routes,
    );
  }
}
