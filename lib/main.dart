import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final FirebaseApp secondaryApp = await Firebase.initializeApp(
    name: 'Secondary',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
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
