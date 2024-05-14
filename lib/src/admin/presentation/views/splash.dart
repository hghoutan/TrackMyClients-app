import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/admin/domain/controllers/auth_controller.dart';
import 'package:trackmyclients_app/src/admin/domain/models/user.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/auth/admin_login.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/main_screen.dart';

import '../../../utils/functions/next_screen.dart';
import '../../../utils/images.dart';
import '../../domain/repositories/firebase_notification_repository.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final notificationsService = NotificationsService();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 2 * 3.141,
    ).animate(_controller);

    Future.delayed(const Duration(seconds: 3), () async {
      await notificationsService.requestPermission();
      await notificationsService.getToken();
      _gotoWelcomePage();
    });

    _controller.repeat();
  }

  Future<void> _gotoWelcomePage() async {
    UserData? user = await ref.watch(authControllerProvider).getUserData();
    setState(() {
      nextScreenReplaceAnimation(
        context,
        user != null ? const MainScreen() : const AdminLoginScreen(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Center(
              child: Image(
                image: AssetImage(Images.appLogo),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 48.0),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value,
                  child: const Image(
                    image: AssetImage(Images.loader),
                    height: 32,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
