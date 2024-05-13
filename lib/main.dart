import 'package:agora_uikit/controllers/rtc_token_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/firebase_options.dart';
import 'package:trackmyclients_app/src/admin/domain/repositories/firebase_notification_repository.dart';
import 'package:trackmyclients_app/src/utils/functions/message_tools.dart';

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final FirebaseApp secondaryApp = await Firebase.initializeApp(
    name: 'Secondary',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotificationService().init();
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
    final LocalNotificationService _localNotificationService =
      LocalNotificationService();
    _localNotificationService.showTimedNotification();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/',
      routes: Routes.routes,
    );
  }
}
