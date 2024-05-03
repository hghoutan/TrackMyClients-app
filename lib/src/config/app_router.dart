import 'package:flutter/material.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/auth/admin_login.dart';

import '../admin/presentation/views/splash.dart';

class Routes {
  static final routes = {
    "/": (context) => const SplashScreen(),
    "/admin-login": (context) => const AdminLoginScreen(),
    "/admin-register": (context) => SizedBox(),
  };
}
