import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmyclients_app/src/admin/domain/controllers/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final authController = ref.watch(authControllerProvider);
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            await authController.signOut();
          },
          child: FaIcon(
            FontAwesomeIcons.powerOff,
            size: 40,
          ),
        ),
      ),
    );
  }
}
