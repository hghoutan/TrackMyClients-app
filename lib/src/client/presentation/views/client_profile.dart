import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmyclients_app/src/client/domain/controllers/client_auth_controller.dart';

import '../../../admin/presentation/views/auth/admin_login.dart';
import '../../../utils/functions/next_screen.dart';

class ClientProfileScreen extends ConsumerWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   final authController = ref.watch(clientAuthControllerProvider);
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            await authController.signOut();
            nextScreenCloseOthersAnimation(context, AdminLoginScreen());
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