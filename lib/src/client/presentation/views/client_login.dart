import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/admin/presentation/widgets/main_button.dart';
import 'package:trackmyclients_app/src/admin/presentation/widgets/text_input.dart';
import 'package:trackmyclients_app/src/client/domain/controllers/client_auth_controller.dart';
import 'package:trackmyclients_app/src/client/presentation/views/client_chat.dart';
import 'package:trackmyclients_app/src/utils/functions/next_screen.dart';

class ClientLoginScreen extends ConsumerStatefulWidget {
  const ClientLoginScreen({super.key});

  @override
  ConsumerState<ClientLoginScreen> createState() => _ClientLoginScreenState();
}

class _ClientLoginScreenState extends ConsumerState<ClientLoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController cIDController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextInput(
              controller: cIDController,
              hintText: 'Company ID',
              validator: (value) {},
            ),
            const SizedBox(height: 22.0),
            CustomTextInput(
              controller: emailController,
              hintText: 'email',
              validator: (value) {},
            ),
            const SizedBox(height: 22.0),
            CustomTextInput(
              controller: passwordController,
              hintText: 'password',
              validator: (value) {},
            ),
            const SizedBox(height: 22.0),
            MainButtonWidget(
                text: 'se connecter',
                style: Theme.of(context).textTheme.titleMedium!,
                onPressed: () async {
                  bool isUser = await ref
                      .read(clientAuthControllerProvider)
                      .signInWithEmailAndPassword(cIDController.text,
                          emailController.text, passwordController.text);
                  if (isUser) {
                    nextScreenAnimation(context, ClientChatScreen(id :cIDController.text));
                  }
                })
          ],
        ),
      ),
    );
  }
}
